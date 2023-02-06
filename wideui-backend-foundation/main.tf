provider "aws" {
  region  = "${var.region}"
}

# create a zip file and copy to s3

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "../wideui-backend"
  output_path = "wideui-backend_lambda.zip"
}


resource "aws_s3_bucket" "b" {
  bucket = "${var.aws_s3_bucket}"
  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_object" "wideui" {
  bucket = "${aws_s3_bucket.b.bucket}"
  key = "${var.zipname}"
  source = data.archive_file.lambda.output_path

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

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_vpc_access_execution" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_dynamo_access_execution" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_lambda_s3_access_execution" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}



resource "aws_lambda_function" "lambda_function" {
  code_signing_config_arn = ""
  description             = ""
  #filename                = data.archive_file.lambda.output_path
  function_name           = "${var.lambda-function}"
  role                    = aws_iam_role.iam_role.arn
  s3_bucket               = aws_s3_bucket.b.bucket
  s3_key                  = aws_s3_bucket_object.wideui.key
  handler                 = "server.handler"
  runtime                 = "nodejs18.x"
  #source_code_hash        = filebase64sha256(data.archive_file.lambda.output_path)
  vpc_config {
    subnet_ids         = ["${var.subnet_public1_id}", "${var.subnet_private_id}", "${var.subnet_public2_id}", "${var.subnet_private2_id}", "${var.subnet_private3_id}"]
    security_group_ids = ["${var.security_group_id}"]
  }
}


resource "aws_apigatewayv2_api" "wideuibackend" {
  name          = "wideui-backend-tf"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "wideuibackend" {
  api_id = aws_apigatewayv2_api.wideuibackend.id

  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "lambda_function" {
  api_id = aws_apigatewayv2_api.wideuibackend.id

  integration_uri    = aws_lambda_function.lambda_function.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "lambda_function" {
  api_id = aws_apigatewayv2_api.wideuibackend.id
  route_key = "$default"

}
resource "aws_apigatewayv2_route" "anyproxy" {
  api_id    = aws_apigatewayv2_api.wideuibackend.id
  route_key = "ANY /{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.lambda_function.id}"
}

resource "aws_apigatewayv2_route" "any" {
  api_id = aws_apigatewayv2_api.wideuibackend.id

  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_function.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.wideuibackend.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.wideuibackend.execution_arn}/*/*"
}

resource "null_resource" "wait_for_lambda_trigger" {
  depends_on   = [aws_lambda_permission.test]
  provisioner "local-exec" {
    command = "sleep 3m"
  }
}

resource "aws_s3_bucket_notification" "my-trigger" {
    bucket = "${aws_s3_bucket.b.bucket}"
    depends_on = [null_resource.wait_for_lambda_trigger]

    lambda_function {
        lambda_function_arn = "${aws_lambda_function.lambda_function.arn}"
        events              = ["s3:ObjectCreated:*"]
        filter_prefix       = "wideui-backend_lambda"
        filter_suffix       = ".zip"
    }
}

resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda_function.arn}"
  principal = "s3.amazonaws.com"
  source_arn = "${aws_s3_bucket.b.arn}"
}


output "bucket_name"{
	value = "${aws_s3_bucket.b.bucket}"
}

output "lambda_function_name"{
	value = "${aws_lambda_function.lambda_function.function_name}"
}


resource aws_apigatewayv2_domain_name domain {
  domain_name     = "${var.domain_name}"
  domain_name_configuration {
  certificate_arn = "${var.certificate_arn}"
  endpoint_type = "REGIONAL"
  security_policy = "TLS_1_2"
  }
}

resource aws_apigatewayv2_api_mapping base_path {
  api_id      = aws_apigatewayv2_api.wideuibackend.id
  domain_name = aws_apigatewayv2_domain_name.domain.id
  stage  = aws_apigatewayv2_stage.wideuibackend.id
}

#resource aws_route53_record a {
#  type     = "A"
#  name     = "${aws_api_gateway_domain_name.domain.domain_name}"
#  zone_id  = "${var.route53_zone_id}"
#
#  alias {
#    evaluate_target_health = false
#    name                   = "${aws_api_gateway_domain_name.domain.cloudfront_domain_name}"
#    zone_id                = "${aws_api_gateway_domain_name.domain.cloudfront_zone_id}"
#  }
##}
