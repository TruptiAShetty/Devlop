provider "aws" {
  profile                 = "default"
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region                  = var.region
}

module "evt_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-${terraform.workspace}-evt-sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
  ]
  egress_rules = ["all-all"]
}

module "sizop_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-${terraform.workspace}-sizop-sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
  ]
  egress_rules = ["all-all"]
}

module "wideonline1_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-${terraform.workspace}-wideonline1-sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
  ]
  egress_rules = ["all-all"]
}

module "wideonline2_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-${terraform.workspace}-wideonline2-sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    },
    {
      from_port   = 22
      to_port     = 22
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
  depends_on                  = [module.evt_sg]
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-${terraform.workspace}-evt-ec2"
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
    }
  ]
}

module "sizop_ec2" {
  depends_on                  = [module.evt_ec2]
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-${terraform.workspace}-sizop-ec2"
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
    }
  ]
}
module "wideonline1_ec2" {
  depends_on                  = [module.sizop_ec2]
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-${terraform.workspace}-wideonline1-ec2"
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
    }
  ]
}

module "wideonline2_ec2" {
  depends_on                  = [module.wideonline1_ec2]
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-${terraform.workspace}-wideonline2-ec2"
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
    }
  ]
}
module "alb_sg" {
  source              = "../../modules/security_group"
  name                = "${var.prefix}-${terraform.workspace}-alb-sg"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp","https-443-tcp"]
  egress_rules        = ["all-all"]
}

module "alb" {
  depends_on         = [module.wideonline2_ec2]
  source             = "../../modules/alb"
  name               = "${var.prefix}-${terraform.workspace}-alb"
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = var.public_subnets
  security_groups    = [module.alb_sg.security_group_id]
  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = module.evt_ec2.id
          port      = 80
        }
      ]
    },
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = module.sizop_ec2.id
          port      = 80
        }
      ]
    },
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = module.wideonline1_ec2.id
          port      = 80
        }
      ]
    },
    {
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = module.wideonline2_ec2.id
          port      = 80
        }
      ]
    }
  ]
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:acm:eu-west-1:901259681273:certificate/a58c0fd2-02ad-4ee7-9850-97b8b2361991"
      target_group_index = 0
    }
  ]
  https_listener_rules = [
    {
      https_listener_index = 0
      priority                = 1
      actions = [{
        type               = "forward"
        target_group_index = 0
      }]
      conditions = [{
        path_patterns = ["/evt*"]
      }]
    },
    {
      https_listener_index = 0
      priority                = 2
      actions = [{
        type               = "forward"
        target_group_index = 1
      }]
      conditions = [{
        path_patterns = ["/sizop*"]
      }]
    },
    {
      https_listener_index = 0
      priority                = 3
      actions = [{
        type               = "forward"
        target_group_index = 2
      }]
      conditions = [{
        path_patterns = ["/wideonline1*"]
      }]
    },
    {
      https_listener_index = 0
      priority                = 4
      actions = [{
        type               = "forward"
        target_group_index = 3
      }]
      conditions = [{
        path_patterns = ["/wideonline2*"]
      }]
    }
  ]
  tags = {
    name = "${var.prefix}-${terraform.workspace}-alb"
  }
}

terraform {
  backend "s3" {
    bucket                  = "wingd-tf-state"
    key                     = "ec2/terraform.tfstate"
    region                  = "eu-west-1"
    profile                 = "default"
    shared_credentials_file = "~/.aws/credentials"
  }
}
