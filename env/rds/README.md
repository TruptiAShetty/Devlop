A)manual steps for the creation of RDS in Dev environment:

    1. Check out the code from the gitlab
                 https://www.wingd.com/gitlab/wide2/aws_infra_terraform.git & git checkout terraform_scripts        
    2. cd to the env folder and then we can see the of ec2 & rds 
    3. cd to Rds folder and then type command "terraform workspace" by typing this command . It can been shown in which workspace basically we are in the "default" workspace.   
       NOTE :Workspaces in Terraform are simply independently managed state files. A workspace contains everything that Terraform needs to manage a given collection of infrastructure, and separate Workspaces function like completely separate working directories. We can manage multiple environments with Workspaces.
    4. Change the parameter vpc_id in dev-terraform.tfvars (which is created from jenkins folder)
    5. Change the parameter subnet_id in dev-terraform.tfvars (which is created from jenkins_folder).Pass the parameter of subnet_id as a private_subnets.
    6. After that we should configure s3 backend by using "terrform init" command
    7.senario :
       7.1 Then we should create workspace by using command "terraform workspace new dev"
                "syntax: terraform workspace new name"
       7.2 After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace we are placed in .
                "command: terraform workspace show"
       7.3 Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.
                "command: terraform plan -var-file dev-terraform.tfvars"
       7.4 Run the terraform apply command 
                "command: terraform apply -var-file dev-terraform.tfvars"
           NOTE : dev RDS resources will be created.
       7.5 If we want to destroy the environment which is created 
                "command: terraform destroy -var-file dev-terraform.tfvars"

B)manual steps for the creation of RDS in QA environment :

    1. Check out the code from the gitlab
                 https://www.wingd.com/gitlab/wide2/aws_infra_terraform.git & git checkout terraform_scripts        
    2. cd to the env folder and then we can see the of ec2 & rds 
    3. cd to rds folder and then type command "terraform workspace" by typing this command . It can been shown in which workspace basically we are in the "default" workspace.   
       NOTE :Workspaces in Terraform are simply independently managed state files. A workspace contains everything that Terraform needs to manage a given collection of infrastructure, and separate Workspaces function like completely separate working directories. We can manage multiple environments with Workspaces.
    4. Change the parameter vpc_id in qa-terraform.tfvars (which is created from the env/vpc folder)
    5. Change the parameter subnet_id in qa-terraform.tfvars (which is created from env/vpc folder). Pass the parameter of subnet_id as a private_subnets.
    6. After that we should configure s3 backend by using terrform init command.
    7.senario
       7.1 Then we should create workspace by usung command "terraform workspace new qa"
               "syntax: terraform workspace new name"
       7.2 After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace placed in .
              "command: terraform workspace show"
       7.3 Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.
              "command: terraform plan -var-file qa-terraform.tfvars"
       7.4 Run the terraform apply command 
               "command: terraform apply -var-file qa-terraform.tfvars"
            NOTE : qa rds resources will be created. 
       7.5 If we want to destroy the environment which is created 
               "command: terraform destroy -var-file qa-terraform.tfvars"

C)manual steps for the creation of RDS in Prod environment :
 
    1. Check out the code from the gitlab
                 https://www.wingd.com/gitlab/wide2/aws_infra_terraform.git & git checkout terraform_scripts        
    2. cd to the env folder and then we can see the of ec2 & rds 
    3. cd to ec2 folder and then type command "terraform workspace" by typing this command . It can been shown in which workspace basically we are in the "default" workspace.   
       NOTE :Workspaces in Terraform are simply independently managed state files. A workspace contains everything that Terraform needs to manage a given collection of infrastructure, and separate Workspaces function like completely separate working directories. We can manage multiple environments with Workspaces.
    4. Change the parameter vpc_id in prod-terraform.tfvars (which is created from the env/vpc folder)
    5. Change the parameter subnet_id in prod-terraform.tfvars (which is created from env/vpc folder). Pass the parameter of subnet_id as a private_subnets.
    6. After that we should configure s3 backend by using terrform init command.
    7.senario :
       7.1 Then we should create workspace by usung command "terraform workspace new prod"
              "syntax: terraform workspace new name"
       7.2 After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace placed in .
              "command: terraform workspace show"
       7.3 Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.
              "command: terraform plan -var-file prod-terraform.tfvars"
       7.4 Run the terraform apply command 
              "command: terraform apply -var-file prod-terraform.tfvars"
           NOTE : prod rds resources will be created .
       7.5 If we want to destroy the environment which is created 
              "command: terraform destroy -var-file prod-terraform.tfvars"


  
                      

  
