provider "aws" {
  region  = "${var.region}"
}

resource "aws_cognito_user_pool" "pool" {
  name = "${var.pool_name}"

//  mfa_configuration          = "OPTIONAL"
//  email_configuration {
//        configuraiton_set = ""
//        email_sending_account = ""
//        from_email_address = ""
//        reply_to_email_address = ""
//
//      }
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
    }


  password_policy {
    minimum_length    = 10
    require_lowercase = false
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

    lambda_config {
      pre_token_generation      = "${var.lambda_arn}"

  }
}

#resource "aws_cognito_user_pool_domain" "main" {
#  domain          = "${var.domain_name}"
#  certificate_arn = "${var.certificate_arn}"
#  user_pool_id    = aws_cognito_user_pool.pool.id
#}

resource "aws_cognito_user" "example" {
  user_pool_id = aws_cognito_user_pool.pool.id
  username     = "Rahamat"

  attributes = {
    email          = "Rahamthulla.Pannekatla@ltts.com"
    email_verified = true
  }
}

resource "aws_cognito_user_group" "main" {
  name         = "winGD-Admin"
  user_pool_id = aws_cognito_user_pool.pool.id
  description  = "Managed by Terraform"
  precedence   = 42
}
resource "aws_cognito_user_group" "service" {
  name         = "winGD-ServiceEngineer"
  user_pool_id = aws_cognito_user_pool.pool.id
  description  = "Managed by Terraform"
  precedence   = 43
}
resource "aws_cognito_user_group" "guest" {
  name         = "winGD-Guest"
  user_pool_id = aws_cognito_user_pool.pool.id
  description  = "Managed by Terraform"
  precedence   = 44
}



resource "aws_cognito_user_pool_client" "client" {
  name = "wideui-dev2-cog"

  user_pool_id = "${aws_cognito_user_pool.pool.id}"

  generate_secret     = true
  explicit_auth_flows = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH"]
  allowed_oauth_scopes = ["aws.cognito.signin.user.admin", "email", "openid", "phone", "profile"]
  allowed_oauth_flows = ["code", "implicit"]
  callback_urls = ["https://wideui.dev2.wingd.digital/auth/login", "https://wideui.dev2.wingd.digital/auth/redirect"]
  logout_urls = ["https://wideui.dev2.wingd.digital/auth/login", "https://wideui.dev2.wingd.digital/auth/redirect"]
  refresh_token_validity = "30"
}
