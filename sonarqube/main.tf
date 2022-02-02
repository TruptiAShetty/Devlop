provider "aws" {
  profile                 = "default"                               //manual update require pass a profile 
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region                  = var.region
}

###############creation of sonar_sg###########
module "sonar_sg" {
  source              = "../modules/security_group"
  name                = "${var.prefix}-sonar-sg"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules       = var.sg_sonar_ingress_rules
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
       description              = "sonar Port"
      from_port                = 9000
      protocol                 = "tcp"
      security_group_id        =module.sonar_sg.security_group_id
      source_security_group_id = var.source_security_group_id                             //manual update require of alb_security_group_id which we are going to launch a sonarqube in alb
      to_port                  = 9000
      type                     = "ingress"
}
############ebs_enabled#########################
resource "aws_ebs_encryption_by_default" "example" {
  enabled = true
}

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


###################creation of sonar_ec2@@@@@@@@@@@@@@@@@

module "sonar_ec2" {
  depends_on                  = [module.sonar_sg]
  source                      = "../modules/ec2"
  name                        = "${var.prefix}-sonar"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.sonar_ec2_instance_type
  iam_instance_profile        = var.iam_instance_profile                                    //manual update require pass ainstance_profile in terraform.tfvars
  monitoring                  = true
  subnet_id                   = var.private_subnet_id                                      // manual update require pass a private subnet_id in terraform .tfvars
  vpc_security_group_ids      = [module.sonar_sg.security_group_id]
  associate_public_ip_address = false 
  user_data                   = file("./provisioner.sh")
  metadata_options = {
    State                       = "applied"
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 8
  }
  ebs_block_device = [                                                    //ebs encrypted..
       {   
           encrypted             = true
           device_name           = "/dev/xvdf"
           volume_size           = 10
       }
   ] 
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.sonar_ec2_volume_size
    },
  ]
  tags = {
    name = "${var.prefix}-sonar"
  }
}

######################creation of a target group attaching to the exisiting alb###############33
resource "aws_lb_target_group" "group4" {
  name     = "sonar4-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.group4.arn
  target_id        = module.sonar_ec2.id
  port             = 9000
}

resource "aws_lb_listener_rule" "rule1" {
  listener_arn = var.alb_listener_arn                                       //manual upadte require for the alb_listerner_arn which is present in exisiting aws_account in terraform.tfvars
  priority     = 11

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group4.arn
  }

  condition {
    host_header {
      values = ["sonar.dev.wingd.digital"]
    }
  }
}

##########s3_backend######################

terraform {
  backend "s3" {
    bucket                  = "wingd-tf-state"                                         //manual update require bucket should present in aws_account
    key                     = "terraform/eu-west-1/sonarqube/terraform.tfstate"
    region                  = "eu-west-1"
    profile                 = "default"                                              //manual update require pass a profile 
    shared_credentials_file = "~/.aws/credentials"
  }
}
