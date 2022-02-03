## Manual update require in terraform.tfvars
           
	   1.private_subnet_id. (instance to launch in private_subnet) 
	   2.vpc_id (vpc_id for instance)
	   3.public_subnets(two public_subnet for creation of alb)
	   4.certificate_arn (certificate arn for the https listerners)
	   5.private_subnet_ids (private_subnet_ids for the vpc endpoints)
	   6.bucket_name_1(access logs for alb)

## Manual steps for the creation of ec2 instances in Dev environment:

    1. Check out the code from the gitlab
                 https://www.wingd.com/gitlab/wide2/aws_infra_terraform.git & git checkout terraform_scripts        
    2. cd to the env folder and then we can see the of ec2 & rds 
    3. cd to ec2 folder and then type command "terraform workspace" by typing this command . It can been shown in which workspace basically we are in the "default" workspace.   
       NOTE :Workspaces in Terraform are simply independently managed state files. A workspace contains everything that Terraform needs to manage a given collection of infrastructure, and separate Workspaces function like completely separate working directories. We can manage multiple environments with Workspaces.
    4. Change the parameter vpc_id in dev-terraform.tfvars (which is created from env/vpc folder)
    5. Change the parameter subnet_id in dev-terraform.tfvars (which is created from env/vpc folder). According to the requirement ec2 should deploy in the private_subnet so pass the parameter of subnet_id as a private_subnet.
    6. Change the parameter public_subnets in dev-terraform.tfvars (which is cretaed from env/vpc_folder) & change the parameter of private_subnet_ids for the selection subnet for the vpc endpoints
    7. After that we should configure s3 backend by using "terrform init" command.
    8.senciorio :
       8.1 Then we should create workspace by using command "terraform workspace new dev"
                "syntax: terraform workspace new name"
       8.2 After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace we are placed in .
                "command: terraform workspace show"
       8.3 Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.
                "command: terraform plan -var-file dev-terraform.tfvars"
            8.3.1 If we want to save the plan we will use a command 
	                command: terraform plan -var-file dev-terraform.tfvars -out="tf.dev-plan"
            8.3.2 After executing the above command the file created name tf.dev-plan to read the content of the file .Please execute the below command
	               "command: terraform show tf.dev-plan"
       8.4 Run the terraform apply command 
                "command: terraform apply -var-file dev-terraform.tfvars"
           NOTE : dev ec2 resources will be created 4 ec2 instance(sizop,evt,wideonline1& wideonline2 which this ec2 which will depoly in the private subnet & ALB 
       8.5 If we want to destroy the environment which is created 
                "command: terraform destroy -var-file dev-terraform.tfvars"
       8.6 If we want to switch from one workspace to another workspace we will use a command.
                "command: terraform workspace select <workpsace name>

## Manual steps for the creation of ec2 instances in QA environment :

    1. Check out the code from the gitlab
                 https://www.wingd.com/gitlab/wide2/aws_infra_terraform.git & git checkout terraform_scripts        
    2. cd to the env folder and then we can see the of ec2 & rds 
    3. cd to ec2 folder and then type command "terraform workspace" by typing this command . It can been shown in which workspace basically we are in the "default" workspace.   
       NOTE :Workspaces in Terraform are simply independently managed state files. A workspace contains everything that Terraform needs to manage a given collection of infrastructure, and separate Workspaces function like completely separate working directories. We can manage multiple environments with Workspaces.
    4. Change the parameter vpc_id in qa-terraform.tfvars (which is created from the env/vpc folder)
    5. Change the parameter subnet_id in qa-terraform.tfvars (which is created from env/vpc folder). According to the requirement ec2 should deploy in the private_subnet so pass the parameter of subnet_id as a private_subnet.
    6. Change the parameter public_subnets in qa-terraform.tfvars (which is cretaed from env/vpc folder) & change the parameter of private_subnet_ids for the selection subnet for the vpc endpoints
    7. After that we should configure s3 backend by using terrform init command.
    8.senario
       8.1 Then we should create workspace by usung command "terraform workspace new qa"
               "syntax: terraform workspace new name"
       8.2 After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace placed in .
              "command: terraform workspace show"
       8.3 Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.
              "command: terraform plan -var-file qa-terraform.tfvars"
	    8.3.1 If we want to save the plan we will use a command
	              command: terraform plan -var-file qa-terraform.tfvars -out="tf.qa-plan"
            8.3.2 After executing the above command the file created name tf.qa-plan to read the content of the file .Please execute the below command
	              "command: terraform show tf.qa-plan"
       8.4 Run the terraform apply command 
               "command: terraform apply -var-file qa-terraform.tfvars"
            NOTE : qa ec2  resources will be created 4 ec2 instance(sizop,evt,wideonline1& wideonline2 which this ec2 which will depoly in the private subnet & ALB.
       8.5 If we want to destroy the environment which is created 
               "command: terraform destroy -var-file qa-terraform.tfvars"
       8.6 If we want to switch from one workspace to another workspace we will use a command.
              "command: terraform workspace select <workpsace name>

## Manual steps for the creation of ec2 instances in Prod environment : 

    1. Check out the code from the gitlab
                 https://www.wingd.com/gitlab/wide2/aws_infra_terraform.git & git checkout terraform_scripts        
    2. cd to the env folder and then we can see the of ec2 & rds 
    3. cd to ec2 folder and then type command "terraform workspace" by typing this command . It can been shown in which workspace basically we are in the "default" workspace.   
       NOTE :Workspaces in Terraform are simply independently managed state files. A workspace contains everything that Terraform needs to manage a given collection of infrastructure, and separate Workspaces function like completely separate working directories. We can manage multiple environments with Workspaces.
    4. Change the parameter vpc_id in prod-terraform.tfvars (which is created from the env/vpc folder)
    5. Change the parameter subnet_id in prod-terraform.tfvars (which is created from env/vpc folder). According to the requirement ec2 should deploy in the private_subnet so pass the parameter of subnet_id as a private_subnet.
    6. Change the parameter public_subnets in prod-terraform.tfvars (which is cretaed from env/vpc folder)  & change the parameter of private_subnet_ids for the selection subnet for the vpc endpoints
    7. After that we should configure s3 backend by using terrform init command.
    8.senario :
       8.1 Then we should create workspace by usung command "terraform workspace new prod"
              "syntax: terraform workspace new name"
       8.2 After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace placed in .
              "command: terraform workspace show"
       8.3 Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.
              "command: terraform plan -var-file prod-terraform.tfvars"
	     8.3.1 If we want to save the plan we will use a command
	             command: terraform plan -var-file prod-terraform.tfvars -out="tf.prod-plan"
	     8.3.2 After executing the above command the file created name tf.prod-plan to read the content of the file .Please execute the below command
	             "command: terraform show tf.prod-plan"
       8.4 Run the terraform apply command 
              "command: terraform apply -var-file prod-terraform.tfvars"
           NOTE : prod ec2  resources will be created 4 ec2 instance(sizop,evt,wideonline1& wideonline2 which this ec2 which will depoly in the private subnet & ALB 
       8.5 If we want to destroy the environment which is created 
              "command: terraform destroy -var-file prod-terraform.tfvars"
       8.6 If we want to switch from one workspace to another workspace we will use a command.
              "command: terraform workspace select <workpsace name>" 
                      

  
