provider "aws" {
  profile                 = "default"                         // Manual Update required for: pass a profile parameter                          
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region                  = var.region
}


###############creation of sizop_security group#########
module "backend_sg" {
  source = "../modules/security_group"
  name   = "${var.prefix}-backend-sg-wideui"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   =  var.ingress_with_cidr_blocks_from_port1
      to_port     =  var.ingress_with_cidr_blocks_to_port1
      protocol    =  var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port2
      to_port     = var.ingress_with_cidr_blocks_to_port2
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port3
      to_port     = var.ingress_with_cidr_blocks_to_port3
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    },
  ]
  egress_with_cidr_blocks = [                                            
   {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0.0/0"
   },
  ]
}

resource "aws_security_group_rule" "ingress_with_source_security_group_id" {
      description              = "backend Port"
      from_port                = var.ingress_with_cidr_blocks_from_port4
      protocol                 = "tcp"
      security_group_id        =module.backend_sg.security_group_id
      source_security_group_id = var.source_security_group_id                                           //manual update require of alb_security_group_id which we are going to launch aport in alb
      to_port                  = var.ingress_with_cidr_blocks_to_port4
      type                     = "ingress"
}

// resource "aws_security_group_rule" "example" {
//   type              = "ingress"
//   from_port         = var.ingress_with_cidr_blocks_from_port4
//   to_port           = var.ingress_with_cidr_blocks_to_port4
//   protocol          = "tcp"
//   cidr_blocks       = ["0.0.0.0/0"]
//   description       = "managed from infrastructure"
//   security_group_id = var.security_group_id               //manual upadte required of alb security group
// }

###############creation of wideonlineapp_security group#########

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  owners = ["099720109477"]
}

############## creation of wideui_frontend_ec2_ec2_instance###############
module "wideui_backend_ec2" {
  source                      = "../modules/ec2"
  name                        = "${var.prefix}-backend-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile                 // pass aparameter instance_profile in terraform.tfvars
  monitoring                  = true
  subnet_id                   = var.private_subnet_id                // pass a parameter private_subnet_id in terraform.tfvars 
  vpc_security_group_ids      = [module.backend_sg.security_group_id] 
  associate_public_ip_address = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
    }
  ]
}

resource "aws_lb_target_group" "group" {
  name     = "wideuibackend-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id                          //manual update require 
}

resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.group.arn
  target_id        = module.wideui_backend_ec2.id
  port             = 5000
}

resource "aws_lb_listener_rule" "rule1" {
  listener_arn = var.alb_listener_arn                                       //manual upadte require for the alb_listerner_arn which is present in exisiting aws_account in terraform.tfvars
  priority     = 17

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group.arn
  }

  condition {
    host_header {
      values = ["wideuibackend.${terraform.workspace}.wingd.digital"]
    }
  }
}
################S3_backend configuration######################
terraform {
  backend "s3" {
    bucket                  = "wideui-tf-state"              // Manual Update required for: pass bucket name ad parameter which is already present in aws_account
    key                     = "wideui/terraform.tfstate"
    region                  = "eu-west-1"
    profile                 = "default"                    // Manual Update required for: pass a profile parameter                                   
    shared_credentials_file = "~/.aws/credentials"
  }
}
