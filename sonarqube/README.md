# Sonarqube Setup
   Sonarqube is open -source static testing analysis software,it is used by developers to manage source code quality and consistency.

## Manual update required in terraform.tfvars

- Private_subnet_id (created from env/vpc folder)
- vpc_id (created from env/vpc folder)
- source_security_group_id (we need to give security group id of the wingd-dev-alb-sg for dev env & wingd-qa-alb-sg for qa env)
- alb_arn(we need to give https:443 alb_arn of wingd-dev-alb for dev env or we need to give https:443 alb_arn of wingd-qa-alb for qa env)


## Prerequisties (All install steps done by infra )

- Source:https://docs.sonarqube.org/latest/requirements/requirements/ 
       
- An EC2 instance with a minimum of 2 GB RAM (`t2.small`)
- `Java 11 installation`

                  amazon-linux-extras list
                  amazon-linux-extras install java-openjdk11.
- SonarQube cannot be run as root on Unix-based systems, so create a dedicated user account for SonarQube if necessary.

- `Installation steps` (this steps are automated through terraform)
      
- Download SonarQube latest verions on to EC2 instace

                    cd /opt wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.2.46101.zip 
-  If unzip command is not found install unzip command 

                    apt install unzip
- extract packages

                    unzip /opt/sonarqube-8.9.2.46101.zip
- Create a new user

                    Useradd <sonaradmin>
- Change ownershipt to the user and Switch to Linux binaries directory to start service

                   chown -R sonaradmin:sonaradmin sonarqube-8.9.2.46101
-  Give full permissions to the folder

                   chmod -R 777 /opt/sonarqube-8.9.2.46101/
- Goto to the sonarqube installed path.

                   cd /opt/sonarqube-8.9.2.46101/bin/linux-x86-64

## Manual Steps to be performed:  

-  GIT:

             git clone https://gitlab.wingd.com/wide2/aws_infra_terraform.git
- Goto sonarqube folder

              cd sonarqube
- For the log file purpose please use the below commands

              5.1 Windows:
	             $env:TF_LOG="TRACE"
		     $env:TF_LOG_PATH="terraform.txt" 
	          5.2 Linux:
	             export TF_LOG=TRACE
		     export TF_LOG_PATH="terraform.txt"
- Make sure the following `S3 Bucket`(wingd-tf-state-t2) available in the AWS console.

  
   Note: Terraform stores information about your infrastructure in a state file. This state file keeps track of resources created by your configuration and maps them to real-world resources.
-  Make sure create a role for the ssm in the aws account where we are going to excute the terraform script. while creation of the role take the policy of "AmazonEC2RoleforSSM" & "AmazonSSMManagedInstanceCore" pass the role name to the "Iam_instance_profile" as a parametre in the terraform.tfvars.
- In the terraform script of main.tf change the `profile parameter,vpc_id,subnet_id,alb_listerner_arn & source_security_group_id` in terraform.tfvars(added inline comment where have to change) in which the s3 bucket has present.
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

   NOTE : dev jenkins instance created ad attached rules to the existing Alb which is created in ec2 folder 
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

	
       terraform plan -var-file dev-terraform.tfvars -out="tf.qa-plan"

- After executing the above command the file created name tf.dev-plan to read the content of the file .Please execute the below command

	                terraform show tf.qa-plan
- Terraform apply command is used to create or introduce changes to real infrastructure. By default, apply scans the current working directory for the configuration and applies the changes appropriately.
Run the terraform apply command 

              terraform apply -var-file qa-terraform.tfvars

   NOTE : dev sonar instance(wingd-dev-sonar) created and attached rules to the existing Alb wings-dev-alb which is created in ec2 folder & qa sonar instance(wingd-qa-sonar) created and attached rules to the existing Alb  wings-qa-alb which is created in ec2 folder
- If we want to destroy the environment which is created 

                terraform destroy -var-file qa-terraform.tfvars

- If we want to switch from one workspace to another workspace we will use a command.

                 terraform workspace select <workpsace name>

    

- After the creation of the resources. the file name "terraform.txt" will be create where all logs are present in terraform.txt

- **steps to be performed to start SonarQube application:**
             
- Login to the sonarqube instance with the command below command
                        
                        aws ssm start-session --target "instance-id" (here instance-id is wingd-dev-sonar instance_id (or)wingd-qa-sonar instance_id)
- sudo su -
- Change the directory with the command 

                         cd /opt/sonarqube-8.9.2.46101/bin/linux-x86-64
- Login into the sonaradmin user (sonaradmin is the new user which is already created by infra)

                         sudo su -sonaradmin
- sonarqube service:

        ./sonar.sh start(sonarqube started)
        ./sonar.sh status(sonarqube status checking)
        ./sonar.sh restart(sonarqube server restart)
        ./sonar.sh stop(sonarqube server stoping purpose)
- Connect to the SonarQube server through the browser. It uses port `9000`

                          https://sonar.dev.wingd.digital
- **Steps to be followed in the server(https://sonar.dev.wingd.digital) & (https://sonar.qa.wingd.digital)** 
             
- Default username and Password

                       username : admin
                       password : admin
- In the next page we can change the password of the SonarQube

                        Old password :admin
                        New password : XXXXX
                        confirm password : XXXX
- In the Righ side of the top <goto my account>
- Goto the security Generate the token to authenticate from jenkins (copy the token which will useful in the jenkins server)       

## Integrate Sonarqube with Jenkins server(https://jenkins.dev.wingd.digital) & (https://jenkins.qa.wingd.digital)

**On Jenkins server**

- ### Install Sonarqube plugin

        1. Goto manage jenkins <manage plugins> click on avaliable search "sonarqube" & install
        2. Configure Sonarqube credentials
                2.1 Goto the <manage jenkins> <manage credentials>.Create a new credentials with a id of sonar_credentials use a secret text copy the token generated in the sonarqube server.
        3. Add Sonarqube to jenkins "configure system"
                3.1  Goto <manage jenkins> <configure system> in sonarqube servers, Add sonarcredentials to the server.

                         Name : SonarQube Server
               Server url :https://sonar.dev.wingd.digital for dev env
               Server url :https://sonar.qa.wingd.digital for qa env
                                          
        4. Install SonarScanner in jenkins.
                4.1  Goto <manage jenkins> <Global tool configuration> in SonarScanner for MSBuild,click on the add SonarScanner for MSbuild follow below set up.
                    4.1.1 Name : SonarScanner for MSBuild (for .NET Project)
                    4.1.2 Check install automatically give version of  "SonarScanner for MSBuild 5.3.2.38712-.NET Core 3.0" (for .NET project)
                4.2  Goto <manage jenkins> <Global tool configuration> in SonarQube Scanner, click on the add Sonarscanner follow below set up
                    4.2.1 Name : SonarQube Scanner 4.6.2.2472(for other project)
                    4.2.2 Check install automatically give version of  "SonarQube Scanner 4.6.2.2472" (for other project)
                4.3 Click apply and save 
        5. Run Pipeline job (which are already provide in the jenkinsfile of the project sizop_deployment,evt,sizop_rest & sizop_web)     
      
       
