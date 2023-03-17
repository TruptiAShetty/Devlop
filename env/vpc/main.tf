provider "aws" {
  region = "${var.region}"
}
####################creation of VPC networking#################### 
module "vpc" {
  source                 = "../../modules/vpc"
  name                   = "${var.prefix}-vpc"
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
####################block public acess######################
resource "aws_s3_account_public_access_block" "example" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
##################s3_backend#############

terraform {
  backend "s3" {
    bucket                  = "wingd-tf-state-t3"                        // Manual Update required for: pass bucket name ad parameter which is already present in aws_account
    key                     = "network/terraform.tfstate"
    region                  = "eu-west-1"
    profile                 = "503263480993_AdministratorAccess"                              // Manual Update required for: pass a profile parameter
    shared_credentials_file = "~/.aws/credentials"
  }
}

