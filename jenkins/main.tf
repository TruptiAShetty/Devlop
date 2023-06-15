provider "aws" {
  region = "${var.region}"
}

##################creation of jenkins security
module "jenkins_sg" {
  source              = "../modules/security_group"
  name                = "${var.prefix}-jenkins-sg"
  vpc_id              = var.vpc_id                                                  // vpc_id in terraform.tfvars
  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules       = var.sg_jenkins_ingress_rules
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
       description              = "allowed from alb"
      from_port                = 8080
      protocol                 = "tcp"
      security_group_id        =module.jenkins_sg.security_group_id
      source_security_group_id = var.source_security_group_id                  // alb_security_group_id which we are going to launch a jenkins in alb
      to_port                  = 8080
      type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_with_source_security_group_id_sonar" {
       description              = "allowed from alb"
      from_port                = 9000
      protocol                 = "tcp"
      security_group_id        =module.jenkins_sg.security_group_id
      source_security_group_id = var.source_security_group_id                  // alb_security_group_id which we are going to launch a jenkins in alb
      to_port                  = 9000
      type                     = "ingress"
}




###################ebs_enabled####################
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


######################creation of ec2_instance#########################

module "jenkins__ec2" {
  depends_on                  = [module.jenkins_sg]
  source                      = "../modules/ec2"
  name                        = "${var.prefix}-jenkins"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.jenkins_ec2_instance_type
  iam_instance_profile        = var.iam_instance_profile                              // pass ainstance_profile in terraform.tfvars
  monitoring                  = true
  subnet_id                   = var.private_subnet_id                                        // pass a private subnet_id in terraform .tfvars
  vpc_security_group_ids      = [module.jenkins_sg.security_group_id]
  associate_public_ip_address = false 
  user_data                   = file("./provisioner.sh")
  metadata_options = {
    State                       = "applied"
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 8
  }
  ebs_block_device = [                                                    // ebs encrypted..
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
      volume_size = var.jenkins_ec2_volume_size
    },
  ]
  tags = {
    name = "${var.prefix}-jenkins"
  }
}


######################creation of a target group attaching to the exisiting alb###############33

resource "aws_lb_target_group" "group4" {
  name     = "jenkins1-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id                      
  health_check {
                   enabled             = true
                    path                = "/login"
                    port                = "traffic-port"
                    healthy_threshold   = 3
                    unhealthy_threshold = 2
                    timeout             = 3
                    interval            = 20
                    protocol            = "HTTP"
                    matcher             = "200-399"
           }

}

resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.group4.arn
  target_id        = module.jenkins__ec2.id
  port             = 8080
}


resource "aws_lb_target_group" "group_sonar" {
  name     = "sonar4-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "attachment2" {
  target_group_arn = aws_lb_target_group.group_sonar.arn
  target_id        = module.jenkins__ec2.id
  port             = 9000
}


resource "aws_lb_listener_rule" "rule1" {
  listener_arn = var.alb_listener_arn                                         // the alb_listerner_arn which is present in exisiting aws_account in terraform.tfvars
  priority     = 10                                                          

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group4.arn
  }

  condition {
    host_header {
      values = ["jenkins.${terraform.workspace}.wingd.digital"]
    }
  }
}


resource "aws_lb_listener_rule" "rule2" {
  listener_arn = var.alb_listener_arn                                       //manual upadte require for the alb_listerner_arn which is present in exisiting aws_account in terraform.tfvars
  priority     = 11

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group_sonar.arn
  }

  condition {
    host_header {
      values = ["sonar.${terraform.workspace}.wingd.digital"]
    }
  }
}


#################s3_backend#######################
terraform {
  backend "s3" {
    bucket                  = "wingd-tf-state-t3"                             // Manual Update required for: bucket should present in aws_account
    key                     = "terraform/eu-west-1/jenkins/terraform.tfstate"
    region                  = "eu-west-1"
    profile                 = "503263480993_AdministratorAccess"                                   // Manual Update required for: pass a profile 
    shared_credentials_file = "~/.aws/credentials"
  }
}
