steps for the creation of VPC in env (QA & PROD)  

    1. Check out the code from the gitlab       
    2. cd to the env folder and then we can see the of ec2, rds & vpc 
    3. cd to vpc folder and then type command "terraform workspace" by typing this command . It can been shown in which workspace basically we are in the "default" workspace.   
       NOTE :Workspaces in Terraform are simply independently managed state files. A workspace contains everything that Terraform needs to manage a given collection of infrastructure, and separate Workspaces function like completely separate working directories. We can manage multiple environments with Workspaces.
    4. Make sure the following S3 Bucket(wingd-tf-state) available in the AWS console.
    Note: Terraform stores information about your infrastructure in a state file. This state file keeps track of resources created by your configuration and maps them to real-world resources.
    5. After that we should configure s3 backend by using terrform init command.
    6.senciorio 1 for vpc for QA environment:
         6.1. Then we should create workspace by usung command "terraform workspace new qa"
                   "command: terraform workspace new qa"
         6.2. After creation of the terraform workspace qa then we can proceed with a command "terraform workspace show" it show in which workspace are we in.
                   "command: terraform workspace show"
         6.3 Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.
                   "command: terraform plan -var-file qa-terraform.tfvars"
	           6.3.1 If we want to save the plan we will use a command
	                 "command: terraform plan -var-file qa-terraform.tfvars -out=tf.qa-plan"
               6.3.2 After executing the above command the file created name tf.qa-plan to read the content of the file .Please execute the below command.
	                 "command: terraform show tf.qa-plan"
         6.4 Run the terraform apply command 
                   "command: terraform apply -var-file qa-terraform.tfvars"
             NOTE : Network resources will be created. 
         6.5 If we want to clean or destroy resouces which are created in the aws account.
                   "command: terraform destroy -var-file qa-terraform.tfvars"
         6.6 If we want to switch from one workspace to another workspace we will use a command.
	          "command: terraform workspace select <workpsace name>"
    7.senciorio 2 for vpc for PROD environment:
         7.1. Then we should create workspace by usung command "terraform workspace new prod"
                    "command: terraform workspace new prod"
         7.2. After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace are we in.
                     "command: terraform workspace show"
         7.3 Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.
                     "command: terraform plan -var-file prod-terraform.tfvars"
		    7.3.1 If we want to save the plan we will use a command
		             "command: terraform plan -var-file prod-terraform.tfvars -out=tf.prod-plan"
                7.3.2  After executing the above command the file created name tf.prod-plan to read the content of the file .Please execute the below command.
		             "command: terraform show tf.prod-plan"
         7.4 Run the terraform apply command 
                     "command: terraform apply -var-file prod-terraform.tfvars"
             NOTE : Network resources will be created. 
         7.5 If we want to clean or destroy resouces which are created in the aws account.
                     "command: terraform destroy -var-file prod-terraform.tfvars"
         7.6 If we want to switch from one workspace to another workspace we will use a command.
	                  "command: terraform workspace select <workpsace name>"
