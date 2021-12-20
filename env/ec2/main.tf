provider "aws" {
  profile                 = "default"                                                 // pass a profile parameter
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region                  = var.region
}
# creation of evt_instance security_group
module "evt_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-${terraform.workspace}-evt-sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = var.ingress_with_cidr_blocks_from_port1
      to_port     = var.ingress_with_cidr_blocks_to_port1
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port2
      to_port     = var.ingress_with_cidr_blocks_to_port2
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
  ]
  egress_rules = ["all-all"]
}
# creation of sizop_instance security_group
module "sizop_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-${terraform.workspace}-sizop-sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   =  var.ingress_with_cidr_blocks_from_port1
      to_port     =  var.ingress_with_cidr_blocks_to_port1
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    },
    {
      from_port   =  var.ingress_with_cidr_blocks_from_port2
      to_port     =  var.ingress_with_cidr_blocks_to_port2
      protocol    =  var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
  ]
  egress_rules = ["all-all"]
}
# creation of wideonline1_instance security_group
module "wideonline1_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-${terraform.workspace}-wideonline1-sg"
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
      from_port   =  var.ingress_with_cidr_blocks_from_port2
      to_port     =  var.ingress_with_cidr_blocks_to_port2
      protocol    =  var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
  ]
  egress_rules = ["all-all"]
}
# creation of wideonline2_instance security_group
module "wideonline2_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-${terraform.workspace}-wideonline2-sg"
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
      from_port   =  var.ingress_with_cidr_blocks_from_port2
      to_port     =  var.ingress_with_cidr_blocks_to_port2
      protocol    =  var.protocol
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

# creation of evt_ec2_instance
module "evt_ec2" {
  depends_on                  = [module.evt_sg]
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-${terraform.workspace}-evt-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.evt_instance_type
  iam_instance_profile        = var.iam_instance_profile                          //pass iam_instance_profile as a parameter which is present in a existing aws_account
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
# creation of sizop_ec2_instance
module "sizop_ec2" {
  depends_on                  = [module.evt_ec2]
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-${terraform.workspace}-sizop-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.sizop_instance_type
  iam_instance_profile        = var.iam_instance_profile                          //pass iam_instance_profile as a parameter which is present in a existing aws_account
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
# creation of wideonline1_ec2_instance
module "wideonline1_ec2" {
  depends_on                  = [module.sizop_ec2]
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-${terraform.workspace}-wideonline1-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.wideonline1_instance_type
  iam_instance_profile        = var.iam_instance_profile                       //pass iam_instance_profile as a parameter which is present in a existing aws_account
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
# creation of wideonline2_ec2_instance
module "wideonline2_ec2" {
  depends_on                  = [module.wideonline1_ec2]
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-${terraform.workspace}-wideonline2-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.wideonline2_instance_type
  iam_instance_profile        = var.iam_instance_profile                     //pass iam_instance_profile as a parameter which is present in a existing aws_account
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
# creation ALB security_group
module "alb_sg" {
  source              = "../../modules/security_group"
  name                = "${var.prefix}-${terraform.workspace}-alb-sg"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = var.sg_alb_ingress_rules
  egress_rules        = ["all-all"]
}
# creation of ALB
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
      backend_protocol = var.backend_protocol
      backend_port     = var.backend_port
      target_type      = "instance"
      targets = [
        {
          target_id = module.evt_ec2.id
          port      = 80
        }
      ]
    },
    {
      backend_protocol = var.backend_protocol
      backend_port     = var.backend_port
      target_type      = "instance"
      targets = [
        {
          target_id = module.sizop_ec2.id
          port      = 80
        }
      ]
    },
    {
      backend_protocol = var.backend_protocol
      backend_port     = var.backend_port
      target_type      = "instance"
      targets = [
        {
          target_id = module.wideonline1_ec2.id
          port      = 80
        }
      ]
    },
    {
      backend_protocol = var.backend_protocol
      backend_port     = var.backend_port
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
      port               = var.https_listeners_port
      protocol           = var.https_listeners_protocol
      certificate_arn    = "arn:aws:acm:eu-west-1:901259681273:certificate/a58c0fd2-02ad-4ee7-9850-97b8b2361991"            //pass certificate_arn as parameter which is already in existing aws_account
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
# S3_backend configuration
terraform {
  backend "s3" {
    bucket                  = "wingd-tf-state"                          //pass bucket name as parameter which is already present in aws_account
    key                     = "ec2/terraform.tfstate"
    region                  = "eu-west-1"
    profile                 = "default"                                // pass a profile parameter
    shared_credentials_file = "~/.aws/credentials"
  }
}
