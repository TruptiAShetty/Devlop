provider "aws" {
  region  = "${var.region}"
}

resource "aws_s3_bucket_object" "pretoken" {
  bucket = "${var.s3_bucket}"
  key = "${var.s3_pretoken_key}"

}

resource "aws_s3_bucket_object" "custom_authorizer" {
  bucket = "${var.s3_bucket}"
  key = "${var.s3_custom_authorizer_key}"

}




data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "iam_role" {
  assume_role_policy = data.aws_iam_policy_document.AWSLambdaTrustPolicy.json
  name               = "${var.iam-role}"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_basic_execution" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_dynamodb_fullaccess_execution" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
resource "aws_lambda_function" "lambda_function_pretoken" {
  code_signing_config_arn = ""
  description             = ""
# # #filename                = data.archive_file.lambda.output_path
  function_name           = "${var.lambda-function_pretoken}"
  role                    = aws_iam_role.iam_role.arn
  s3_bucket               = aws_s3_bucket_object.pretoken.bucket
  s3_key                  = aws_s3_bucket_object.pretoken.key
  handler                 = "lambda_function_pretoken.lambda_handler"
  runtime                 = "python3.9"
#  source_code_hash        = filebase64sha256(data.archive_file.lambda.output_path)
}


resource "aws_lambda_function" "lambda_function_custom_authorizer" {
  code_signing_config_arn = ""
  description             = ""
# # #filename                = data.archive_file.lambda.output_path
  function_name           = "${var.lambda-function_custom_authorizer}"
  role                    = aws_iam_role.iam_role.arn
  s3_bucket               = aws_s3_bucket_object.custom_authorizer.bucket
  s3_key                  = aws_s3_bucket_object.custom_authorizer.key
  handler                 = "lambda_function_custom_authorizer.lambda_handler"
  runtime                 = "python3.9"
#  source_code_hash        = filebase64sha256(data.archive_file.lambda.output_path)
}






