# Steps for deploying Terraform scripts 
      
- **STEP1**For deploying basic infrastructure using terraform scripts,Please go the env folder and then to ***vpc*** folder follow the `README.MD` in the link.
	  	       https://gitlab.wingd.com/wide2/aws_infra_terraform/-/tree/terraform_scripts/env/vpc
 - By following the above link,We can deploy the infrastructure like VPC Networking and vpc_flow_logs

- **STEP2** For deplying environmental ec2 infrastructure using terraform scripts,please goto the env folder ***ec2*** follow the `README.md` in the link.
	               https://gitlab.wingd.com/wide2/aws_infra_terraform/-/tree/terraform_scripts/env/ec2
- By following the above link,We can deploy the infrastructure like Ec2 in private subnet,ALB,VPC endpoints,WAF & RDS 
- **STEP3** For deploying jenkins instance using terraform script please goto the ***jenkins*** folder follow the `README.md` in the link.
		       https://gitlab.wingd.com/wide2/aws_infra_terraform/-/blob/terraform_scripts/jenkins/
- By follwing the above link, we can deploy jenkins instance in private_subnet and adding rules to the existing alb
- **STEP4** For deploying ***sonarqube*** instance using terraform script please goto the jenkins folder follow the `README.md` in the link.
		                         https://gitlab.wingd.com/wide2/aws_infra_terraform/-/blob/terraform_scripts/sonarqube/
- By follwing the above link, we can deploy sonarqube instance in private_subnet and adding rules to the existing alb
- **STEP5** For deploying ***rds*** instance using terraform script please goto the jenkins folder follow the `README.md` in the link.
                   https://gitlab.wingd.com/wide2/aws_infra_terraform/-/tree/terraform_scripts/env/rds
- By follwing the above link, we can deploy RDS instance for DEV,QA & PROD.


#Steps for creating s3, cloudfront using terraform and updating the frontend build in bucket
- The script is located at https://gitlab.wingd.com/wide2/aws_infra_terraform/-/tree/master/s3andcloudfront

- The Jenkinsfile for this located in root directory of the repo  https://gitlab.wingd.com/wide2/aws_infra_terraform/

- The jenkinsjob is located at https://jenkins.dev.wingd.digital/job/wideui/job/Frontend_Terraform/

- Once we run the job it will create both s3 and cloudfront, output the bucket name and distribution id to variable

- We use these variables, copy files to s3 bucket created and run invalidation command on cloudfront distribution created after copying files
              

					  
