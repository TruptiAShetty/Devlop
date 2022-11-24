resource "aws_s3_bucket" "b" {
  bucket = "wideui-frontend-terraform"

  tags = {
    Name = "Frontend Bucket Terrafrom"
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

locals {
  s3_origin_id = "wideui-frontend-terraform.s3.eu-west-1.amazonaws.com"
}

resource "aws_cloudfront_origin_access_identity" "s3_cf_oai" {
      comment= "origin identity for CF"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
        domain_name              = aws_s3_bucket.b.bucket_regional_domain_name
        origin_id                = local.s3_origin_id
        s3_origin_config {
          origin_access_identity = aws_cloudfront_origin_access_identity.s3_cf_oai.cloudfront_access_identity_path
   }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Wideui_frontend"
  default_root_object = "index.html"


  aliases = ["wideui-test.dev.wingd.digital"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "development"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn = "arn:aws:acm:us-east-1:901259681273:certificate/7879f625-e0a3-47b5-940d-fc0313debe5c"
    ssl_support_method = "sni-only"
  }
}


output "bucket_name" {
     value = "${aws_s3_bucket.b.bucket}"
}

output "cloudfront_id" {
    value = "${aws_cloudfront_distribution.s3_distribution.id}"
}


/*  
    Copyright (c) 2022 Winterthur Gas & Diesel Ltd. (https://wingd.com)
    All rights reserved.
    All files in this SharePoint shall not be copied and/or distributed and/or used for other purposes than agreed without the prior written permission of Winterthur Gas & Diesel Ltd.
*/
