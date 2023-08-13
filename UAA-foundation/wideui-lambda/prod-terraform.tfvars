region                    = "eu-west-1"                         //Region where aws resources will be provided
iam-role                  = "wideui-UAA-role"           //IAM role name which will be created
lambda-function_custom_authorizer         = "wideui-custom-authorizer"                  //Lambda-fucntion Nname
s3_bucket                 = "wide.prod.config"       //bucket name
s3_custom_authorizer_key                  = "wideui-custom-authorizer.zip"              // s3 object key

lambda-function_pretoken = "wideui-pretoken"

s3_pretoken_key           = "wideui-pretoken.zip"               // s3 object key


