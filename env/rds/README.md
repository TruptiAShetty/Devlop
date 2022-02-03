# Steps for deploying RDS
## Manual update require in terraform.tfvars

- private_subnet_ids(created from vpc folder)
- vpc_id(created from voc folder)

## Manual steps for the creation of RDS in Dev environment:

- Check out the code from the gitlab
                 https://www.wingd.com/gitlab/wide2/aws_infra_terraform.git & git checkout terraform_scripts        
- cd to the env folder and then we can see the of ec2 & rds 
- cd to Rds folder and then type command "terraform workspace" by typing this command . It can been shown in which workspace basically we are in the `default` workspace.   
       NOTE :Workspaces in Terraform are simply independently managed state files. A workspace contains everything that Terraform needs to manage a given collection of infrastructure, and separate Workspaces function like completely separate working directories. We can manage multiple environments with Workspaces.
- Change the parameter vpc_id in dev-terraform.tfvars (which is created from env/vpc folder)
- Change the parameter subnet_id in dev-terraform.tfvars (which is created from env/vpc folder).Pass the parameter of subnet_id as a private_subnets.
- After that we should configure s3 backend by using `terrform init` command

**senario**

- Then we should create workspace by using command "terraform workspace new dev"

               terraform workspace new name

- After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace we are placed in .

                terraform workspace show
- Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.

                 terraform plan -var-file dev-terraform.tfvars
- If we want to save the plan we will use a command

	                 terraform plan -var-file dev-terraform.tfvars -out="tf.dev-plan"
- After executing the above command the file created name tf.dev-plan to read the content of the file .Please execute the below command

	                terraform show tf.dev-plan

- Run the terraform apply command 

                 terraform apply -var-file dev-terraform.tfvars


   NOTE : dev RDS resources will be created.
- If we want to destroy the environment which is created 

                 terraform destroy -var-file dev-terraform.tfvars

- If we want to switch from one workspace to another workspace we will use a command.

                 terraform workspace select <workpsace name>

## Manual steps for the creation of RDS in QA environment :

- Check out the code from the gitlab
                 https://www.wingd.com/gitlab/wide2/aws_infra_terraform.git & git checkout terraform_scripts        
- cd to the env folder and then we can see the of ec2 & rds 
- cd to rds folder and then type command "terraform workspace" by typing this command . It can been shown in which workspace basically we are in the `default` workspace.   
       NOTE :Workspaces in Terraform are simply independently managed state files. A workspace contains everything that Terraform needs to manage a given collection of infrastructure, and separate Workspaces function like completely separate working directories. We can manage multiple environments with Workspaces.
- Change the parameter vpc_id in qa-terraform.tfvars (which is created from the env/vpc folder)
- Change the parameter subnet_id in qa-terraform.tfvars (which is created from env/vpc folder). Pass the parameter of subnet_id as a private_subnets.
- After that we should configure s3 backend by using `terrform init` command.


**senario**

- Then we should create workspace by usung command "terraform workspace new qa"

               terraform workspace new qa
- After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace placed in .

               terraform workspace show
- Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.

               terraform plan -var-file qa-terraform.tfvars

- If we want to save the plan we will use a command

	                 terraform plan -var-file qa-terraform.tfvars -out="tf.qa-plan"
- After executing the above command the file created name tf.qa-plan to read the content of the file .Please execute the below command

	                terraform show tf.qa-plan
- Run the terraform apply command

               terraform apply -var-file qa-terraform.tfvars

  NOTE : qa rds resources will be created. 
- If we want to destroy the environment which is created 

              terraform destroy -var-file qa-terraform.tfvars
- If we want to switch from one workspace to another workspace we will use a command.

              terraform workspace select <workpsace name>


## Manual steps for the creation of RDS in Prod environment :
 
- Check out the code from the gitlab
                 https://www.wingd.com/gitlab/wide2/aws_infra_terraform.git & git checkout terraform_scripts        
- cd to the env folder and then we can see the of ec2 & rds 
- cd to ec2 folder and then type command "terraform workspace" by typing this command . It can been shown in which workspace basically we are in the `default` workspace.   
       NOTE :Workspaces in Terraform are simply independently managed state files. A workspace contains everything that Terraform needs to manage a given collection of infrastructure, and separate Workspaces function like completely separate working directories. We can manage multiple environments with Workspaces.
-  Change the parameter vpc_id in prod-terraform.tfvars (which is created from the env/vpc folder)
- Change the parameter subnet_id in prod-terraform.tfvars (which is created from env/vpc folder). Pass the parameter of subnet_id as a private_subnets.
- After that we should configure s3 backend by using `terrform init` command.

**senario** 

- Then we should create workspace by usung command "terraform workspace new prod"

              terraform workspace new prod
- After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace placed in .

              terraform workspace show
- Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.

              terraform plan -var-file prod-terraform.tfvars
-  If we want to save the plan we will use a command

	       terraform plan -var-file prod-terraform.tfvars -out="tf.prod-plan"
- After executing the above command the file created name tf.prod-plan to read the content of the file .Please execute the below command

	       terraform show tf.prod-plan
- Run the terraform apply command 

             terraform apply -var-file prod-terraform.tfvars

  NOTE : prod rds resources will be created .
- If we want to destroy the environment which is created 

              terraform destroy -var-file prod-terraform.tfvars
- If we want to switch from one workspace to another workspace we will use a command.

             terraform workspace select <workpsace name>



  
                      

  
