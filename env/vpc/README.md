## Manual update require in terraform.tfvars

                 1.bucket_name 

## steps for the creation of VPC in env (DEV,QA & PROD)  

    1. Check out the code from the gitlab       
    2. cd to the env folder and then we can see the of ec2, rds & vpc 
    3. cd to vpc folder and then type command "terraform workspace" by typing this command . It can been shown in which workspace basically we are in the "default" workspace.   
       NOTE :Workspaces in Terraform are simply independently managed state files. A workspace contains everything that Terraform needs to manage a given collection of infrastructure, and separate Workspaces function like completely separate working directories. We can manage multiple environments with Workspaces.
    4. Make sure the following S3 Bucket(wingd-tf-state) available in the AWS console.
    Note: Terraform stores information about your infrastructure in a state file. This state file keeps track of resources created by your configuration and maps them to real-world resources.
    5. After that we should configure s3 backend by using terrform init command.
    6. For the log file purpose please use the below commands
              5.1 Windows:
	             $env:TF_LOG="TRACE"
		     $env:TF_LOG_PATH="terraform.txt" 
	          5.2 Linux:
	             export TF_LOG=TRACE
		     export TF_LOG_PATH="terraform.txt"

    7.`senciorio 1` for vpc for DEV environment:
         7.1. Then we should create workspace by usung command "terraform workspace new dev"
                   "command: terraform workspace new dev"
         7.2. After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace are we in.
                   "command: terraform workspace show"
         7.3 Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.
                   "command: terraform plan -var-file dev-terraform.tfvars"
	           7.3.1 If we want to save the plan we will use a command
	                  command: terraform plan -var-file dev-terraform.tfvars -out="tf.dev-plan"
               7.3.2 After executing the above command the file created name tf.dev-plan to read the content of the file .Please execute the below command.
	                 "command: terraform show tf.dev-plan"
         7.4 Run the terraform apply command 
                   "command: terraform apply -var-file dev-terraform.tfvars"
             NOTE : Network resources will be created. 
         7.5 If we want to clean or destroy resouces which are created in the aws account.
                   "command: terraform destroy -var-file dev-terraform.tfvars"
         7.6 If we want to switch from one workspace to another workspace we will use a command.
	          "command: terraform workspace select <workpsace name>"
    8.`senciorio 2` for vpc for QA environment:
         8.1. Then we should create workspace by usung command "terraform workspace new qa"
                   "command: terraform workspace new qa"
         8.2. After creation of the terraform workspace qa then we can proceed with a command "terraform workspace show" it show in which workspace are we in.
                   "command: terraform workspace show"
         8.3 Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.
                   "command: terraform plan -var-file qa-terraform.tfvars"
	           8.3.1 If we want to save the plan we will use a command
	                  command: terraform plan -var-file qa-terraform.tfvars -out="tf.qa-plan"
               8.3.2 After executing the above command the file created name tf.qa-plan to read the content of the file .Please execute the below command.
	                 "command: terraform show tf.qa-plan"
         8.4 Run the terraform apply command 
                   "command: terraform apply -var-file qa-terraform.tfvars"
             NOTE : Network resources will be created. 
         8.5 If we want to clean or destroy resouces which are created in the aws account.
                   "command: terraform destroy -var-file qa-terraform.tfvars"
         8.6 If we want to switch from one workspace to another workspace we will use a command.
	          "command: terraform workspace select <workpsace name>"
    9.`senciorio 3` for vpc for PROD environment:
         9.1. Then we should create workspace by usung command "terraform workspace new prod"
                    "command: terraform workspace new prod"
         9.2. After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace are we in.
                     "command: terraform workspace show"
         9.3 Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.
                     "command: terraform plan -var-file prod-terraform.tfvars"
		    9.3.1 If we want to save the plan we will use a command
		             command: terraform plan -var-file prod-terraform.tfvars -out="tf.prod-plan"
                9.3.2  After executing the above command the file created name tf.prod-plan to read the content of the file .Please execute the below command.
		             "command: terraform show tf.prod-plan"
         9.4 Run the terraform apply command 
                     "command: terraform apply -var-file prod-terraform.tfvars"
             NOTE : Network resources will be created. 
         9.5 If we want to clean or destroy resouces which are created in the aws account.
                     "command: terraform destroy -var-file prod-terraform.tfvars"
         9.6 If we want to switch from one workspace to another workspace we will use a command.
	                  "command: terraform workspace select <workpsace name>"
