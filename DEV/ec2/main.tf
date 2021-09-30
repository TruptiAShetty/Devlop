provider "aws" {
  profile                 = "default"
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region                  = var.region
}

module "evt_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-evt-sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
  ]
  egress_rules = ["all-all"]
}

module "sizop_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-sizop-sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
  ]
  egress_rules = ["all-all"]
}

module "wideonline1_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-wideonline1-sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
  ]
  egress_rules = ["all-all"]
}
module "wideonline2_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-wideonline2-sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
  ]
  egress_rules = ["all-all"]
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


module "evt_ec2" {
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-evt-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.evt_instance_type
  iam_instance_profile        = var.iam_instance_profile
  monitoring                  = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.evt_sg.security_group_id]
  associate_public_ip_address = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.volume_size
    },
  ]
}

module "sizop_ec2" {
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-sizop-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.sizop_instance_type
  iam_instance_profile        = var.iam_instance_profile
  monitoring                  = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.sizop_sg.security_group_id]
  associate_public_ip_address = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.volume_size
    },
  ]
}

module "wideonline1_ec2" {
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-wideonline1-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.wideonline1_instance_type
  iam_instance_profile        = var.iam_instance_profile
  monitoring                  = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.wideonline1_sg.security_group_id]
  associate_public_ip_address = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.volume_size
    },
  ]
}

module "wideonline2_ec2" {
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-wideonline2-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.wideonline2_instance_type
  iam_instance_profile        = var.iam_instance_profile
  monitoring                  = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [module.wideonline2_sg.security_group_id]
  associate_public_ip_address = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = var.volume_size
    },
  ]
}

resource "aws_lb_target_group" "group1" {
  name     = "${var.prefix}-evt-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "attachment1" {
  target_group_arn = aws_lb_target_group.group1.arn
  target_id        = module.evt_ec2.id
  port             = 80
}

resource "aws_lb_listener_rule" "rule1" {
  listener_arn = var.alb_listener_arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group1.arn
  }

  condition {
    path_pattern {
      values = ["/evt*"]
    }
  }
}

resource "aws_lb_target_group" "group2" {
  name     = "${var.prefix}-sizop-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "attachment2" {
  target_group_arn = aws_lb_target_group.group2.arn
  target_id        = module.sizop_ec2.id
  port             = 80
}

resource "aws_lb_listener_rule" "rule2" {
  listener_arn = var.alb_listener_arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group2.arn
  }

  condition {
    path_pattern {
      values = ["/sizop*"]
    }
  }
}

resource "aws_lb_target_group" "group3" {
  name     = "${var.prefix}-wideonline1-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
resource "aws_lb_target_group_attachment" "attachment3" {
  target_group_arn = aws_lb_target_group.group3.arn
  target_id        = module.wideonline1_ec2.id
  port             = 80
}

resource "aws_lb_listener_rule" "rule3" {
  listener_arn = var.alb_listener_arn
  priority     = 4

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group3.arn
  }

  condition {
    path_pattern {
      values = ["/wideonline1*"]
    }
  }
}

resource "aws_lb_target_group" "group4" {
  name     = "${var.prefix}-wideonline2-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "attachment4" {
  target_group_arn = aws_lb_target_group.group4.arn
  target_id        = module.wideonline2_ec2.id
  port             = 80
}

resource "aws_lb_listener_rule" "rule4" {
  listener_arn = var.alb_listener_arn
  priority     = 5

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group4.arn
  }

  condition {
    path_pattern {
      values = ["/wideonline2*"]
    }
  }
}

/* terraform {
  backend "s3" {
    bucket                  = "wingd-tf-state"
    key                     = "terraform/eu-west-1/jenkins/terraform.tfstate"
    region                  = "eu-west-1"
    profile                 = "default"
    shared_credentials_file = "~/.aws/credentials"
  }
} */

