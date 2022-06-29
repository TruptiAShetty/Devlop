# Manual steps to deploy wideui-backend instance in private_subnet 
## Manual update require

- Private_subnet_id (which is already present in AWS_account )
- vpc_id (which is already present in AWS_account wingd_vpc)
- source_security_group_id (we need to give security group id of the wingd-dev-alb-sg for dev (or) wingd-qa-alb-sg for qa.
- alb_arn(we need to give https:443 alb_arn)
## Steps:

### Local machine setup:

- terraform required.(terraform version = 1.0.7)
          Installation guide:
          https://www.terraform.io/docs/cli/install/apt.html
- Git required.
	      Installation guide:
	      https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
- Awscli required.(awscli version = 1.18.69 )
          Installation guide:
          https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
        1.4) SSM plugin to be installed
           Installation guide:
           https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-debian
		
- Configure aws credentials : 
      Export the aws_access_key ,secrete_key & token 
                      Eg: export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                          export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                          export AWS_SESSION_TOKEN= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

-  GIT:
          git clone "https://www.wingd.com/gitlab/wide2/aws_infra_terraform"  
-  Goto jenkins folder
         cd wideui
- For the log file purpose please use the below commands

                      
             5.1 Windows:
		             $env:TF_LOG="TRACE"
			     $env:TF_LOG_PATH="terraform.txt" 
		    5.2 Linux:
		             export TF_LOG=TRACE
			     export TF_LOG_PATH="terraform.txt"
                
- Make sure the following `S3 Bucket`(wideui-tf-state) available in the AWS console.
        Note: Terraform stores information about your infrastructure in a state file. This state file keeps track of resources created by your configuration and maps them to real-world resources.
        

- Make sure create a role for the ssm in the aws account where we are going to excute the terraform script. while creation of the role take the policy of 'AmazonEC2RoleforSSM' & "AmazonSSMManagedInstanceCore" pass the role name to the `Iam_instance_profile` as a parametre in the terraform.tfvars.
- In the teraform script of main.tf change the profile parameter in which the s3 bucket has present.
- In the terraform script of main.tf change the `profile parameter,vpc_id,subnet_id,alb_listerner_arn & source_security_group_id` in terraform.tfvars & (added inline comment where have to change) in which the s3 bucket has present.

- Run the terraform init command which initiates the modules & versions
                  terraform init

                    
- #### **senario1**
- Then we should create workspace by using command "terraform workspace new dev"

                 terraform workspace new dev

- After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace we are placed in .

                 terraform workspace show

-  The terraform plan command evaluates a Terraform configuration to determine the desired state of all the resources it declares, then compares that desired state to the real infrastructure objects being managed with the current working directory and workspace. Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.

        terraform plan -var-file dev-terraform.tfvars
    

-  If we want to save the plan we will use a command 

	
       terraform plan -var-file dev-terraform.tfvars -out="tf.dev-plan"

- After executing the above command the file created name tf.dev-plan to read the content of the file .Please execute the below command

	                terraform show tf.dev-plan
                        
- Terraform apply command is used to create or introduce changes to real infrastructure. By default, apply scans the current working directory for the configuration and applies the changes appropriately.
Run the terraform apply command 

              terraform apply -var-file dev-terraform.tfvars

   NOTE : dev wideui-backend instance created ad attached rules to the existing Alb which is created in ec2 folder 
   
- If we want to destroy the environment which is created 

                terraform destroy -var-file dev-terraform.tfvars

- If we want to switch from one workspace to another workspace we will use a command.

                 terraform workspace select <workpsace name>

- #### **senario2**
- hen we should create workspace by using command "terraform workspace new dev"

                 terraform workspace new qa

- After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace we are placed in .

                 terraform workspace show

-  The terraform plan command evaluates a Terraform configuration to determine the desired state of all the resources it declares, then compares that desired state to the real infrastructure objects being managed with the current working directory and workspace. Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.

        terraform plan -var-file qa-terraform.tfvars
    

-  If we want to save the plan we will use a command 

	
       terraform plan -var-file qa-terraform.tfvars -out="tf.qa-plan"

- After executing the above command the file created name tf.dev-plan to read the content of the file .Please execute the below command

	                terraform show tf.qa-plan
- Terraform apply command is used to create or introduce changes to real infrastructure. By default, apply scans the current working directory for the configuration and applies the changes appropriately.
Run the terraform apply command 

              terraform apply -var-file qa-terraform.tfvars

   NOTE : qa jenkins instance created ad attached rules to the existing Alb which is created in ec2 folder 
- If we want to destroy the environment which is created 

                terraform destroy -var-file qa-terraform.tfvars

- If we want to switch from one workspace to another workspace we will use a command.

                 terraform workspace select <workpsace name>

    
                 terraform destroy -var-file qa-terraform.tfvars(for qa)


                    


 #### **senario3**
- hen we should create workspace by using command "terraform workspace new dev"

                 terraform workspace new prod

- After creation of the terraform workspace dev then we can proceed with a command "terraform workspace show" it show in which workspace we are placed in .

                 terraform workspace show

-  The terraform plan command evaluates a Terraform configuration to determine the desired state of all the resources it declares, then compares that desired state to the real infrastructure objects being managed with the current working directory and workspace. Then we can excute the command terraform plan it will shows after are the resources going to implement in the aws console.

        terraform plan -var-file prod-terraform.tfvars
    

-  If we want to save the plan we will use a command 

	
       terraform plan -var-file qa-terraform.tfvars -out="tf.prod-plan"

- After executing the above command the file created name tf.prod-plan to read the content of the file .Please execute the below command

	                terraform show tf.prod-plan
                    
- Terraform apply command is used to create or introduce changes to real infrastructure. By default, apply scans the current working directory for the configuration and applies the changes appropriately.
Run the terraform apply command 

              terraform apply -var-file prod-terraform.tfvars

   NOTE : qa jenkins instance created ad attached rules to the existing Alb which is created in ec2 folder 
- If we want to destroy the environment which is created 

                terraform destroy -var-file prod-terraform.tfvars

- If we want to switch from one workspace to another workspace we will use a command.

                 terraform workspace select <workpsace name>

    
- After the creation of the resources. the file name "terraform.txt" will be create where all logs are present in terraform.txt

- After the creation of the resources we can clean by using the command.

                 terraform destroy -var-file dev-terraform.tfvars(for dev)
                 terraform destroy -var-file qa-terraform.tfvars(for qa)
