region                    = "eu-west-1"				//Region where aws resources will be provided

subnet_private_id 	  = "subnet-0e6c44a845af7acc6"          //Private Subnet ID
subnet_private2_id        = "subnet-0c0ef2187457f77ca"		//Private subnet ID
subnet_private3_id        = "subnet-0d1dd2906edc66bb0"		//Private subnet ID
subnet_public1_id  	  = "subnet-08b93304e1f050484"		//Public subnet ID (the subnets will be attached to the lambda function for communitcation to other services like rds in vpc)
subnet_public2_id         = "subnet-08e5b21aa0c35c890"          //Public Subnet ID
security_group_id	  = "sg-09eec733dea2dbd91"		//Security group ID (This is wideui-backend security group ID, currently we need these roles)

iam-role 		  = "wideui-backend-lambda-role"		//IAM role name which will be created 
lambda-function 	  = "wideui-backend"			//Lambda-fucntion Nname

aws_s3_bucket             = "wideui-backend-qa"			//S3 bucket name
bucket_name                = "wideui-backend-qa"		//Description of the  bucket
zipname                   = "wideui-backend-lambda.zip"		//ZIP file name (this will be backend code, this will be deployed as zip to lambda fucntion from s3)
domain_name               = "wideui-backend.qa.wingd.digital" 	//Domain name that will be associated with the API gateway URL
certificate_arn           = "arn:aws:acm:eu-west-1:624603455002:certificate/1ca8a5aa-d6bb-41ea-858b-5de58eea61f9"	//Certificate that will be used with the domain *.dev.wingd.digital
