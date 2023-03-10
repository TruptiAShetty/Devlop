region = "eu-west-1"

aws_s3_bucket = "wideui-qa-test-frontend"

bucket_name = "Frontend Bucket"

bucket_acl = "private"

domains = ["wideui.qa-test.wingd.digital"]   // add multiple domains using comma seperator

cert_arn = "arn:aws:acm:us-east-1:901259681273:certificate/7879f625-e0a3-47b5-940d-fc0313debe5c"
restriction = "none"

restriction_env = "qa"

cache_policy = "Managed-CachingOptimized"

cookie_config = "none"

header_config = "none"

query_config = "none"

doc_root = "container/latest/index.html"

