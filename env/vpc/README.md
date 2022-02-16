# Steps to deploy nework(vpc)

## Manual update require in terraform.tfvars

- bucket_name 

## steps for the creation of VPC in env (DEV,QA & PROD)  

- Check out the code from the gitlab       
- cd to the env folder and then we can see the of ec2, rds & vpc 
- cd to vpc folder and then type command "terraform workspace" by typing this command . It can been shown in which workspace basically we are in the `default` workspace.   
       NOTE :Workspaces in Terraform are simply independently managed state files. A workspace contains everything that Terraform needs to manage a given collection of infrastructure, and separate Workspaces function like completely separate working directories. We can manage multiple environments with Workspaces.
- Make sure the following `S3 Bucket`(wingd-tf-state) available in the AWS console.

    Note: Terraform stores information about your infrastructure in a state file. This state file keeps track of resources created by your configuration and maps them to real-world resources.

- After that we should configure s3 backend by using `terraform init` command.
- For the log file purpose please use the below commands

              5.1 Windows:
	             $env:TF_LOG="TRACE"
		     $env:TF_LOG_PATH="terraform.txt" 
	          5.2 Linux:
	             export TF_LOG=TRACE
		     export TF_LOG_PATH="terraform.txt"

**senciorio 1 for vpc for `DEV` environment**

- Then we should create workspace by usung command "terraform workspace new dev"

           terraform workspace new dev

- After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace are we in.

                   terraform workspace show
-  Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.

                   terraform plan -var-file dev-terraform.tfvars
- If we want to save the plan we will use a command

	                 terraform plan -var-file dev-terraform.tfvars -out="tf.dev-plan"
-  After executing the above command the file created name tf.dev-plan to read the content of the file .Please execute the below command.

	                terraform show tf.dev-plan
- Run the terraform apply command 

                   terraform apply -var-file dev-terraform.tfvars
             NOTE : Network resources will be created. 
-  If we want to clean or destroy resouces which are created in the aws account.

                   terraform destroy -var-file dev-terraform.tfvars
- If we want to switch from one workspace to another workspace we will use a command.

	          terraform workspace select <workpsace name>"
              
**senciorio 2 for vpc for `QA` environment**
- Then we should create workspace by usung command "terraform workspace new qa"

                  terraform workspace new qa
- After creation of the terraform workspace qa then we can proceed with a command "terraform workspace show" it show in which workspace are we in.

                  terraform workspace show
- Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.

                   terraform plan -var-file qa-terraform.tfvars
- If we want to save the plan we will use a command

	                terraform plan -var-file qa-terraform.tfvars -out="tf.qa-plan"
- After executing the above command the file created name tf.qa-plan to read the content of the file .Please execute the below command.

	                terraform show tf.qa-plan
- Run the terraform apply command 

                   terraform apply -var-file qa-terraform.tfvars
             NOTE : Network resources will be created. 
- If we want to clean or destroy resouces which are created in the aws account.

                terraform destroy -var-file qa-terraform.tfvars
-  If we want to switch from one workspace to another workspace we will use a command.

	          terraform workspace select <workpsace name>

**senciorio 3 for vpc for `PROD` environment**

- Then we should create workspace by usung command "terraform workspace new prod"

                terraform workspace new prod
                
- After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace are we in.

                     terraform workspace show
- Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.

                    terraform plan -var-file prod-terraform.tfvars
- If we want to save the plan we will use a command

		        terraform plan -var-file prod-terraform.tfvars -out="tf.prod-plan"
-  After executing the above command the file created name tf.prod-plan to read the content of the file .Please execute the below command.

		             terraform show tf.prod-plan
- Run the terraform apply command 

                    terraform apply -var-file prod-terraform.tfvars
    NOTE : Network resources will be created. 
- If we want to clean or destroy resouces which are created in the aws account.

                    terraform destroy -var-file prod-terraform.tfvars
- If we want to switch from one workspace to another workspace we will use a command.

	             terraform workspace select <workpsace name>
