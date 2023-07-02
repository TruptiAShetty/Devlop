variable "region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "iam-role" {
   type = string
   description = "IAM role"
   default = "UAA-setup"

}

variable "lambda-function_pretoken" {
   type = string
   description = "lambda function name"
   default = "wideui-pretoken-test"

}


variable "lambda-function_custom_authorizer" {
   type = string
   description = "lambda function name"
   default = "wideui-custom-authorizer-test"

}


variable "s3_bucket" {
   type = string
   description = "s3 bucket name"
   default = "wideui-backend-tf"

}

variable "s3_pretoken_key" {
   type = string
   description = "S3 object key"
   

}

variable "s3_custom_authorizer_key" {
	type = string
	description = "s3 object key"

}

#variable "APIID" {
#       type = string
#        description = "BAckend API gateway ID"

#}



