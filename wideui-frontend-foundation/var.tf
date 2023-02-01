variable "region" {
   default = "eu-west-1"

}

variable "aws_s3_bucket"{
  description = "give bucket name"
  type        = string

}

variable "bucket_name"{
   description = "Value of tag name of bucket"
   type = string

}

variable "bucket_acl"{
  description = "bucket acl"
  type        = string

}

variable "domains"{
   description = "provide the alias for cloudfront"
   type = list(string)

}

variable "cert_arn"{
   description = "provide the certificate SSL"
   type = string
}

variable "restriction"{
   description = "geographical restriction"
   type = string
}

variable "restriction_env"{
    description = "environment name (dev, qa, prod)"
    type = string

}

variable "cache_policy"{
   description = "caching policy"
   type = string

}

variable "cookie_config" {
    description = "cookie configuration"
    type = string
}

variable "header_config" {
    description = "header configurtion"
    type = string

}

variable "query_config" {
   description = "query string configuration"
   type = string
}

variable "doc_root"{
   description = "document root"
   type = string
}
