// ------Below config is for S3---------
region = "eu-west-1"

// TODO: update enviroment dev/qa/prod
aws_s3_bucket = "wideui-qa-frontend"

//description of the bukcet
bucket_name = "Frontend Bucket"
bucket_acl = "private"

// ------Below config is for CloudFront---------

// TODO: update enviroment dev/qa/prod
domains = ["wideui.qa.wingd.digital"]   // add multiple domains using comma seperator

// TODO: update certificate of the domain
cert_arn = "arn:aws:acm:us-east-1:624603455002:certificate/7532c953-5a7b-4435-9dac-c1b3273e816b"

// TODO: update the service Tag (key/value)
restriction_env = "qa"

restriction = "none"
cache_policy = "Managed-CachingOptimized"
cookie_config = "none"
header_config = "none"
query_config = "none"
doc_root = "container/latest/index.html"
