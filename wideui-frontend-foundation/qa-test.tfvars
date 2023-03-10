region = "eu-west-1"

aws_s3_bucket = "wideui-qa-test-frontend"

bucket_name = "Frontend Bucket"

bucket_acl = "private"

domains = ["wideui.qa-test.wingd.digital"]   // add multiple domains using comma seperator

cert_arn = "arn:aws:acm:eu-west-1:901259681273:certificate/3f404b71-f1a1-4b8f-9c82-4dd062fc9e16"

restriction = "none"

restriction_env = "qa"

cache_policy = "Managed-CachingOptimized"

cookie_config = "none"

header_config = "none"

query_config = "none"

doc_root = "container/latest/index.html"

