provider "aws" {
  profile                 = "default"
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region                  = var.region
}
# creation of VPC networking 
module "vpc" {
  source                 = "../modules/vpc"
  name                   = "${var.prefix}_vpc"
  cidr                   = var.vpc_cidr
  azs                    = var.azs
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  enable_dns_hostnames   = var.enable_dns_hostnames
  enable_dns_support     = var.enable_dns_support
  tags = {
    name = "${var.prefix}_vpc"
  }
}
# creation of jenkins_instance security_group
module "jenkins_sg" {
  depends_on          = [module.vpc]
  source              = "../modules/security_group"
  name                = "${var.prefix}-jenkins-sg"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules       = var.sg_jenkins_ingress_rules
  ingress_with_cidr_blocks = [
    {
      from_port   = var.ingress_with_cidr_blocks_from_port
      to_port     = var.ingress_with_cidr_blocks_to_port
      protocol    = var.protocol
      description = "Jenkins Port"
      cidr_blocks = var.vpc_cidr
    },
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


# creation of ec2_instance
module "jenkins_ec2" {
  depends_on                  = [module.jenkins_sg]
  source                      = "../modules/ec2"
  name                        = "${var.prefix}-jenkins"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.jenkins_ec2_instance_type
  iam_instance_profile        = var.iam_instance_profile
  monitoring                  = true
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [module.jenkins_sg.security_group_id]
  associate_public_ip_address = false 
  user_data                   = file("./provisioner.sh")
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
# creation of ALB security_group
module "alb_sg" {
  depends_on          = [module.vpc]
  source              = "../modules/security_group"
  name                = "${var.prefix}-alb-sg"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = var.sg_alb_ingress_rules
  egress_rules        = ["all-all"]
}
# creation of ALB
module "alb" {
  depends_on         = [module.jenkins_ec2]
  source             = "../modules/alb"
  name               = "${var.prefix}-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  security_groups    = [module.alb_sg.security_group_id]
  target_groups = [
    {
      backend_protocol = var.backend_protocol
      backend_port     = var.backend_port
      target_type      = "instance"
      targets = [
        {
          target_id = module.jenkins_ec2.id
          port      = 8080
        }
      ]
    }
  ]
  https_listeners = [
    {
      port               = var.https_listeners_port
      protocol           = var.https_listeners_protocol
      certificate_arn    = "arn:aws:acm:eu-west-1:901259681273:certificate/a58c0fd2-02ad-4ee7-9850-97b8b2361991"
      target_group_index = 0
    }
  ]
  tags = {
    name = "${var.prefix}-alb"
  }
}
# s3_backend configuration
terraform {
  backend "s3" {
    bucket                  = "wingd-tf-state"
    key                     = "terraform/eu-west-1/jenkins/terraform.tfstate"
    region                  = "eu-west-1"
    profile                 = "default"
    shared_credentials_file = "~/.aws/credentials"
  }
}
