provider "aws" {
  profile                 = "default"      // pass a profile parameter
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region                  = var.region
}
####################creation of VPC networking#################### 
module "vpc" {
  source                 = "../../modules/vpc"
  name                   = "${var.prefix}_${terraform.workspace}_vpc"
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
    name = "${var.prefix}_${terraform.workspace}_vpc"
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

  bucket        = var.bucket_name                    //pass a bucket_name for the creation in the terraform.tfvars 
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
terraform {
  backend "s3" {
    bucket                  = "ganesh-tf-stae12"                        //pass bucket name ad parameter which is already present in aws_account
    key                     = "network/terraform.tfstate"
    region                  = "eu-west-1"
    profile                 = "default"                              // pass a profile parameter
    shared_credentials_file = "~/.aws/credentials"
  }
}

