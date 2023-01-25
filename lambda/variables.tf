variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment (dev / stage / prod)"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "iam-role" {
   type = string
   description = "IAM role"
   default = "wideui-role2"

}

variable "lambda-function" {
   type = string
   description = "lambda function name"
   default = "wideui-backend2"

}

variable "subnet_public1_id" {
  type        = string
  description = "Public subnet CIDR"
}

variable "subnet_private_id" {
  type        = string
  description = "Private subnet CIDR"
}


variable "subnet_public2_id" {
  type        = string
  description = "Public subnet CIDR"
}

variable "subnet_private2_id" {
  type        = string
  description = "Private subnet CIDR"
}

variable "subnet_private3_id" {
  type        = string
  description = "Private subnet CIDR"
}


variable "security_group_id"{
   type = string
   description = "Security Grourp ID"
}



variable "aws_s3_bucket_object"{
  description = "give bucket name"
  type        = string

}

variable bucketname {
  description = "Bucket name"
}

variable zipname {
  description = "zip file name"
}

#variable domain_name {
#  description = "Custom domain name."
#}

#variable certificate_arn {
#  description = "ACM certificate ARN."
#}

#variable route53_zone_id {
#  description = "Route53 hosted zone ID."
#}
