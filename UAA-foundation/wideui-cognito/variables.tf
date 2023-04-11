variable "lambda_arn" {
   type = string

}

variable "pool_name" {
   type = string
   default = "wideui-dev3"
}

#variable domain_name {
 # description = "Custom domain name."
#}

variable certificate_arn {
  description = "ACM certificate ARN."
}

variable region {
   
}

