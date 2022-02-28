provider "aws" {
  profile                 = "default"                         // Manual Update required for: pass a profile parameter                          
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region                  = var.region
}
##################vpc endpoints##############
resource "aws_vpc_endpoint" "ec2" {
  vpc_id            = var.vpc_id                            // pass a parameter in terraform.tfvars
  service_name      = "com.amazonaws.eu-west-1.ec2"
  vpc_endpoint_type = "Interface"
  subnet_ids        =  var.subnet_vpc_endpoint             // pass a parameter in terraform.tfvars
  security_group_ids = [module.evt_sg.security_group_id]
  private_dns_enabled = true
  tags = {
      Name = "vpc-endpoints"
 }
}
##################Block public access for account#######################
resource "aws_s3_account_public_access_block" "example" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
####################Block public access for bucket####################
resource "aws_s3_bucket_public_access_block" "s3Public" {
       bucket                = var.bucket_name_1
       block_public_acls     = true
       block_public_policy   = true
      restrict_public_buckets= true
      ignore_public_acls     = true
}
##################alb_acess_log_bucket #####################
data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "elb_logs" {
  bucket = var.bucket_name_1                           //pass a bucket_name for the creation in the terraform.tfvars if we want we can edit the name
  #acl    = "private"
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
################ebs_enabled######################
resource "aws_ebs_encryption_by_default" "example" {                     //ebs enabled
  enabled = true
}


##############creation of evt_security group#########
module "evt_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-frontend-sg-evt"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
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
    } 
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
resource "aws_security_group_rule" "ingress_with_source_security_group_id1" {
      description              = "allowed from alb_sg"
      from_port                = var.ingress_with_cidr_blocks_from_port1
      protocol                 = var.protocol
      security_group_id        =module.evt_sg.security_group_id
      source_security_group_id =  module.alb_sg.security_group_id
      to_port                  = var.ingress_with_cidr_blocks_to_port1
      type                     = "ingress"
}
###############creation of sizop_security group#########
module "sizop_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-frontend-sg-sizop"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   =  var.ingress_with_cidr_blocks_from_port2
      to_port     =  var.ingress_with_cidr_blocks_to_port2
      protocol    =  var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port3
      to_port     = var.ingress_with_cidr_blocks_to_port3
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
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
resource "aws_security_group_rule" "ingress_with_source_security_group_id2" {
      description              = "allowed from alb_sg"
      from_port                = var.ingress_with_cidr_blocks_from_port1
      protocol                 = var.protocol
      security_group_id        = module.sizop_sg.security_group_id
      source_security_group_id =  module.alb_sg.security_group_id
      to_port                  = var.ingress_with_cidr_blocks_to_port1
      type                     = "ingress"
}

###############creation of wideonlineapp_security group#########
module "wideonline1_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-frontend-sg-wideonlineapp"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   =  var.ingress_with_cidr_blocks_from_port2
      to_port     =  var.ingress_with_cidr_blocks_to_port2
      protocol    =  var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port3
      to_port     = var.ingress_with_cidr_blocks_to_port3
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
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
resource "aws_security_group_rule" "ingress_with_source_security_group_id3" {
      description              = "allowed from alb_sg"
      from_port                = var.ingress_with_cidr_blocks_from_port1
      protocol                 = var.protocol
      security_group_id        = module.wideonline1_sg.security_group_id
      source_security_group_id =  module.alb_sg.security_group_id
      to_port                  = var.ingress_with_cidr_blocks_to_port1
      type                     = "ingress"
}
##################creation of wideonlineapi_security group#########
module "wideonline2_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-backend-sg-wideonlineapi"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   =  var.ingress_with_cidr_blocks_from_port2
      to_port     =  var.ingress_with_cidr_blocks_to_port2
      protocol    =  var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    },
    {
      from_port   = var.ingress_with_cidr_blocks_from_port3
      to_port     = var.ingress_with_cidr_blocks_to_port3
      protocol    = var.protocol
      description = "The protocol. If not icmp, tcp, udp, or all use the"
      cidr_blocks = var.vpc_cidr_range
    }
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
resource "aws_security_group_rule" "ingress_with_source_security_group_id4" {
      description              = "allowed from alb_sg"
      from_port                = var.ingress_with_cidr_blocks_from_port1
      protocol                 = var.protocol
      security_group_id        = module.wideonline2_sg.security_group_id
      source_security_group_id = module.alb_sg.security_group_id
      to_port                  = var.ingress_with_cidr_blocks_to_port1
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

############## creation of evt_ec2_instance###############
module "evt_ec2" {
  depends_on                  = [module.evt_sg]
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-evt-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.evt_instance_type
  iam_instance_profile        = var.iam_instance_profile                 // pass aparameter instance_profile in terraform.tfvars
  monitoring                  = true
  subnet_id                   = var.private_subnet_id                   // pass a parameter private_subnet_id in terraform.tfvars 
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
################ creation of sizop_ec2_instance##################
module "sizop_ec2" {
  depends_on                  = [module.evt_ec2]
  source                      = "../../modules/ec2"
  name                        = "${var.prefix}-${terraform.workspace}-sizop-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.sizop_instance_type
  iam_instance_profile        = var.iam_instance_profile
  monitoring                  = true
  subnet_id                   = var.private_subnet_id
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
  name                        = "${var.prefix}-wideonline-app-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.wideonline1_instance_type
  iam_instance_profile        = var.iam_instance_profile
  monitoring                  = true
  subnet_id                   = var.private_subnet_id
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
  name                        = "${var.prefix}-wideonlineapi-ec2"
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.wideonline2_instance_type
  iam_instance_profile        = var.iam_instance_profile
  monitoring                  = true
  subnet_id                   = var.private_subnet_id
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

###################creation of ALb security group######################
module "alb_sg" {
  source              = "../../modules/security_group"
  name                = "${var.prefix}_alb_sg"
  vpc_id              = var.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = var.sg_alb_ingress_rules
  ingress_with_ipv6_cidr_blocks = [
    {
      from_port        = 80 
      to_port          = 80
      protocol         = var.protocol
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = var.protocol
      description      = "Service ports (ipv6)"
      ipv6_cidr_blocks = "::/0"
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
  tags = {
    Name = "${var.prefix}_alb_sg"
  }
}
################## creation of ALB##################################
module "alb" {
  depends_on         = [module.wideonline2_ec2]
  source             = "../../modules/alb"
  name               = "${var.prefix}-alb"
  load_balancer_type = "application"
  vpc_id             = var.vpc_id
  subnets            = var.public_subnets                              // in dev-terraform.tfvars,qa-terraform.tfvars & prod-terraform.tfvars
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
      name             = "evt-target"
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
      name             = "sizop-target"
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
      name             = "wideonlineapp-target"
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
      name             = "wideonlineapi-target"
      targets = [
        {
          target_id = module.wideonline2_ec2.id
          port      = 80
        }
      ]
    }
  ]
  http_tcp_listeners = [
   {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
   https_listeners = [
    {
      port               = var.https_listeners_port
      protocol           = var.https_listeners_protocol
      certificate_arn    = var.certificate_arn                          // pass certificate_arn as parameter which is already in existing aws_account
      action_type          = "fixed-response"
      fixed_response  = {
           content_type = "text/plain"
           message_body = "503"
           status_code  = "503"
       }
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
        host_headers = ["evt.${terraform.workspace}.wingd.digital"]
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
        host_headers = ["sizop.${terraform.workspace}.wingd.digital"]
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
        host_headers = ["shippingcompany.${terraform.workspace}.wingd.digital"]
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
        host_headers = ["ticketing.${terraform.workspace}.wingd.digital"]
      }]
    },
    {
      https_listener_index = 0
      priority                = 5
      actions = [{
        type               = "forward"
        target_group_index = 3
      }]
      conditions = [{
        host_headers = ["wideapi.${terraform.workspace}.wingd.digital"]
      }]
    },
  ]
  tags = {
    name = "${var.prefix}-alb"
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



################S3_backend configuration######################
terraform {
  backend "s3" {
    bucket                  = "wingd-tf-state"              // Manual Update required for: pass bucket name ad parameter which is already present in aws_account
    key                     = "ec2/terraform.tfstate"
    region                  = "eu-west-1"
    profile                 = "default"                    // Manual Update required for: pass a profile parameter                                   
    shared_credentials_file = "~/.aws/credentials"
  }
}
