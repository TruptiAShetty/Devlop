provider "aws" {
  profile                 = "default"      //manual update required pass a profile parameter
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region                  = var.region
}

############### creation of VPC networking##################################
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
  igw_tags = {
    Name = "${var.prefix}_internet"
  }
  nat_gateway_tags = {
    Name = "${var.prefix}_natgateway"
  }
  nat_eip_tags = {
    Name = "${var.prefix}_NAT-IP"
  }

}

##############vpc_flow_logs########################
resource "aws_flow_log" "example" {
  log_destination      =  module.s3_bucket.this_s3_bucket_arn
  log_destination_type = "s3"
  traffic_type         = "REJECT"
  vpc_id               = module.vpc.vpc_id
  tags = {
    Name = "vpc-flow-logs-s3-bucket"
  }
}
##################creation of s3 bucket#################
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 1.0"

  bucket        = var.bucket_name                     //manual update required pass a bucket_name for the creation in the terraform.tfvars if we want we can edit the name  
  policy        = data.aws_iam_policy_document.flow_log_s3.json
  force_destroy = true
  acl                     = "private"
  restrict_public_buckets = true
  block_public_policy     = true
  block_public_acls       = true
  ignore_public_acls      = true
  versioning = {
    enabled = true
  }

  tags = {
    Name = "vpc-flow-logs-s3-bucket"
  }
}
##################policy attached to s3 bucket#################
data "aws_iam_policy_document" "flow_log_s3" {
  statement {
    sid = "AWSLogDeliveryWrite"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:PutObject"]

     resources = ["arn:aws:s3:::${var.prefix}-logs}/AWSLogs/*"]
  }

  statement {
    sid = "AWSLogDeliveryAclCheck"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = ["s3:GetBucketAcl"]

    resources = ["arn:aws:s3:::${var.bucket_name}"]
  }
}
##################alb_acess_log_bucket #####################
data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "elb_logs" {
  bucket = var.bucket_name_1                           //manual update required pass a bucket_name_1 as parameter if we want we can edit in terraform.tfvars
  acl    = "private"
  force_destroy = true

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.bucket_name_1}/AWSLogs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}
################ creation of jenkins_instance security_group############
module "jenkins_sg" {
  source              = "../modules/security_group"
  name                = "${var.prefix}_jenkins_sg"
  vpc_id              = module.vpc.vpc_id
  ingress_rules       = var.sg_jenkins_ingress_rules
  ingress_cidr_blocks = [var.vpc_cidr]
  egress_with_cidr_blocks = [                                            
   {
    from_port        = var.egress_with_cidr_blocks_from_port
    to_port          = var.egress_with_cidr_blocks_to_port
    protocol         = "-1"
    cidr_blocks      = var.sg_engress_cidr_block
   },
  ]
  tags = {
    name = "${var.prefix}_jenkins_sg"
  }
}

resource "aws_security_group_rule" "ingress_with_source_security_group_id" {
       description              = "Jenkins Port"
      from_port                = 8080
      protocol                 = "tcp"
      security_group_id        =module.jenkins_sg.security_group_id
      source_security_group_id = module.alb_sg.security_group_id
      to_port                  = 8080
      type                     = "ingress"
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


###################### creation of ec2_instance###########################
module "jenkins_ec2" {
  depends_on                  = [module.jenkins_sg]
  source                      = "../modules/ec2"
  name                        = "${var.prefix}-jenkins"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.jenkins_ec2_instance_type
  iam_instance_profile        = var.iam_instance_profile             //manual update required pass iam_instance_profile as a parameter which is  already present in a existing aws_account
  monitoring                  = true
  subnet_id                   = module.vpc.private_subnets[0]
  vpc_security_group_ids      = [module.jenkins_sg.security_group_id]
  associate_public_ip_address = false                                 //enabled auto-assign public-ip if not replace type with false
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
      volume_size = var.jenkins_ec2_volume_size
    },
  ]
}
#####################vpc_endpoints##############
resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.eu-west-1.ec2"
  vpc_endpoint_type = "Interface"
  subnet_ids        =  [module.vpc.private_subnets[0]]                              //subnet is selected for vpc_endpoint
  security_group_ids = [module.jenkins_sg.security_group_id]
  private_dns_enabled = true
}
#####################creation of ALB security_group###########################
module "alb_sg" {
  depends_on          = [module.vpc]
  source              = "../modules/security_group"
  name                = "${var.prefix}_alb_sg"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = var.sg_alb_ingress_rules
  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
    },

  ]
  egress_with_cidr_blocks = [
     {
         from_port        = var.egress_with_cidr_blocks_from_port
         to_port          = var.egress_with_cidr_blocks_to_port
         protocol         = "-1"
         cidr_blocks      = var.sg_engress_cidr_block
        
     },
  ]
  tags = {
    Name = "${var.prefix}_alb_sg"
  }
}
################## creation of ALB##################################
module "alb" {
  depends_on         = [module.jenkins_ec2]
  source             = "../modules/alb"
  name               = "${var.prefix}-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  security_groups    = [module.alb_sg.security_group_id]
  enable_deletion_protection = true                                      //deletion_pritection enable..
  drop_invalid_header_fields = true
  access_logs = {                                                         //access_logs_for alb..
     bucket = "${aws_s3_bucket.elb_logs.bucket}"
  }
  target_groups = [
    {
      backend_protocol = var.backend_protocol
      backend_port     = var.backend_port
      target_type      = "instance"
      name             = "${var.prefix}-jenkins"
      health_check = {
                   enabled             = true
                   interval            = 30
                    path                = "/login"
                    port                = "traffic-port"
                    healthy_threshold   = 3
                    unhealthy_threshold = 2
                    timeout             = 3
                    interval            = 20
                    protocol            = "HTTP"
                    matcher             = "200-399"
           }
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
      certificate_arn    = "arn:aws:acm:eu-west-1:901259681273:certificate/a58c0fd2-02ad-4ee7-9850-97b8b2361991"      //manual update required pass certificate_arn as parameter which is already in existing aws_account 
      target_group_index = 0
    }
  ]

  
  tags = {
    Name = "${var.prefix}-alb"
  }
}



######################creation of WAF########################
resource "aws_wafv2_web_acl" "my_web_acl" {
  name  = "my-web-acl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "RateLimit"
    priority = 1

    action {
      block {}
    }
   statement {

      rate_based_statement {
        aggregate_key_type = "IP"
        limit              = 500
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimit"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "my-web-acl"
    sampled_requests_enabled   = false
  }
}

##########WAF association to ALB resource################

resource "aws_wafv2_web_acl_association" "web_acl_association_my_lb" {
  resource_arn = module.alb.lb_arn
  web_acl_arn  = aws_wafv2_web_acl.my_web_acl.arn
}


#################### s3_backend configuration###################
terraform {
  backend "s3" {
    bucket                  = "wingd-tf-state"                        //manual update required pass bucket name ad parameter which is already present in aws_account
    key                     = "terraform/eu-west-1/jenkins/terraform.tfstate"
    region                  = "eu-west-1"
    profile                 = "default"                              //manual update required pass a profile parameter
    shared_credentials_file = "~/.aws.credentials"
  }
}

