
provider "aws"{
  region = "${var.region}"

}

resource "aws_s3_bucket" "b" {
  bucket = "${var.aws_s3_bucket}"

    website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name = var.bucket_name
  }
}



locals {
  s3_origin_id = "${var.aws_s3_bucket}.s3.eu-west-1.amazonaws.com"
}

resource "aws_cloudfront_origin_access_identity" "s3_cf_oai" {
      comment= "access-identity-${local.s3_origin_id}"
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
  comment             = "wideui-frontend"
  default_root_object = "${var.doc_root}"


  aliases = var.domains

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
      restriction_type = "${var.restriction}"
    }
  }

  tags = {
    Environment = var.restriction_env
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    acm_certificate_arn = "${var.cert_arn}"
    ssl_support_method = "sni-only"
  }
}


data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.b.arn}/*"]
   principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3_cf_oai.iam_arn]
    }
  }
}
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.b.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
resource "aws_s3_bucket_public_access_block" "s3_bucket_acl" {
  bucket = aws_s3_bucket.b.id
  block_public_acls       = true
  block_public_policy     = true
}



output "bucket_name" {
     value = "${aws_s3_bucket.b.bucket}"
}

output "cloudfront_id" {
    value = "${aws_cloudfront_distribution.s3_distribution.id}"
}

output "cloudfron_dns"{
   value = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
}


/*  
    Copyright (c) 2022 Winterthur Gas & Diesel Ltd. (https://wingd.com)
    All rights reserved.
    All files in this SharePoint shall not be copied and/or distributed and/or used for other purposes than agreed without the prior written permission of Winterthur Gas & Diesel Ltd.
*/
