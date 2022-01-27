Sonarqube Setup
   Sonarqube is open -source static testing analysis software,it is used by developers to manage source code quality and consistency.

Prerequisties (All install steps done by infra )
  
   1.Source:https://docs.sonarqube.org/latest/requirements/requirements/ 
       
       1.1 An EC2 instance with a minimum of 2 GB RAM (t2.small)
       1.2 Java 11 installation
             amazon-linux-extras list
             amazon-linux-extras install java-openjdk11.
       1.3 SonarQube cannot be run as root on Unix-based systems, so create a dedicated user account for SonarQube if necessary.

   2.Installation steps (this steps are automated through terraform)
      
      2.1 Download SonarQube latest verions on to EC2 instace
             cd /opt  
             wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.2.46101.zip 
      2.2 If unzip command is not found install unzip command 
             apt install unzip
      2.3 extract packages
             unzip /opt/sonarqube-8.9.2.46101.zip
      2.4 Create a new user
             Useradd <sonaradmin>
      2.5 Change ownershipt to the user and Switch to Linux binaries directory to start service
             chown -R sonaradmin:sonaradmin sonarqube-8.9.2.46101
      2.6 Give full permissions to the folder
             chmod -R 777 /opt/sonarqube-8.9.2.46101/
      2.7 Goto to the sonarqube installed path.
             cd /opt/sonarqube-8.9.2.46101/bin/linux-x86-64

A) Manual Steps to be performed:    
      1. GIT:
             git clone https://gitlab.wingd.com/wide2/aws_infra_terraform.git
      2. Goto sonarqube folder
              cd sonarqube
      3. For the log file purpose please use the below commands
                  5.1 Windows:
	             $env:TF_LOG="TRACE"
		     $env:TF_LOG_PATH="terraform.txt" 
	          5.2 Linux:
	             export TF_LOG=TRACE
		     export TF_LOG_PATH="terraform.txt"
      6. Make sure the following S3 Bucket(wingd-tf-state) available in the AWS console.
          Note: Terraform stores information about your infrastructure in a state file. This state file keeps track of resources created by your configuration and maps them to real-world resources.
      7. Make sure create a role for the ssm in the aws account where we are going to excute the terraform script. while creation of the role take the policy of "AmazonEC2RoleforSSM" & "AmazonSSMManagedInstanceCore" pass the role name to the "Iam_instance_profile" as a parametre in the terraform.tfvars.
      8. In the terraform script of main.tf change the profile parameter,vpc_id,subnet_id,alb_listerner_arn(added inline comment where have to change) in which the s3 bucket has present.
      9. Run the terraform init command which initiates the modules & versions 
                 terraform init
      10. The terraform plan command evaluates a Terraform configuration to determine the desired state of all the resources it declares, then compares that desired state to the real infrastructure objects being managed with the current working directory and workspace.
                 terraform plan
      11. For the saving plan of terraform what are going to create we will use a command
                 terraform plan -out="tf.plan"
      12. After executing the above command we can see the file name "tf.plan" as been created . we will read the content of the tf.plan by using below command.
                 terraform show tf.plan 
      13. Terraform apply command is used to create or introduce changes to real infrastructure. By default, apply scans the current working directory for the configuration and applies the changes appropriately.
                 terraform apply
           Note: Sonarqube instance in private subnet & listerns_rules added to the existiing alb
      14. After the creation of the resources. the file name "terraform.txt" will be create where all logs are present in terraform.txt
      15.steps to be performed to start SonarQube application:
             
	     15.1 Login to the sonarqube instance with the command below command
                        "command:aws ssm start-session --target "instance-id" (here instance-id is wingd-sonar instance_id)
             15.2 sudo su -
             15.3 Change the directory with the command 
                         cd /opt/sonarqube-8.9.2.46101/bin/linux-x86-64
             15.4 Login into the sonaradmin user (sonaradmin is the new user which is already created by infra)
                         sudo su -sonaradmin
             15.5 sonarqube service:
                         15.5.1 ./sonar.sh start(sonarqube started)
                         15.5.2 ./sonar.sh status(sonarqube status checking)
                         15.5.3 ./sonar.sh restart(sonarqube server restart)
                         15.5.4 ./sonar.sh stop(sonarqube server stoping purpose)
             15.6 Connect to the SonarQube server through the browser. It uses port 9000
                          https://sonar.dev.wingd.digital
       16. Steps to be followed in the server(http://sonar.dev.wingd.digital):
             
	     16.1 Default username and Password
                       username : admin
                       password : admin
             16.2 In the next page we can change the password of the SonarQube
                        Old password :admin
                        New password : XXXXX
                        confirm password : XXXX
             16.3 In the Righ side of the top <goto my account>
             16.4 Goto the security Generate the token to authenticate from jenkins (copy the token which will useful in the jenkins server)       

B) Integrate Sonarqube with Jenkins server:
1. On Jenkins server:
           1.1 Install Sonarqube plugin
                 1.1.1 Goto manage jenkins <manage plugins> click on avaliable search "sonarqube" & install
           1.2 Configure Sonarqube credentials
                 1.2.1 Goto the <manage jenkins> <manage credentials>.Create a new credentials with a id of sonar_credentials use a secret text copy the token generated in the sonarqube server.
           1.3 Add Sonarqube to jenkins "configure system"
                 1.3.1  Goto <manage jenkins> <configure system> in sonarqube servers, Add sonarcredentials to the server.
                                         Name : SonarQube Server
                                         Server url :https://sonar.dev.wingd.digital
                                          
           1.4 Install SonarScanner in jenkins.
                 1.4.1  Goto <manage jenkins> <Global tool configuration> in SonarScanner for MSBuild,click on the add SonarScanner for MSbuild follow below set up.
                                     2.4.1.1 Name : SonarScanner for MSBuild (for .NET Project)
                                     2.4.1.2 Check install automatically give version of  "SonarScanner for MSBuild 5.3.2.38712-.NET Core 3.0" (for .NET project)
                 1.4.2  Goto <manage jenkins> <Global tool configuration> in SonarQube Scanner, click on the add Sonarscanner follow below set up
                                     2.4.1.2 Name : SonarQube Scanner 4.6.2.2472(for other project)
                                     2.4.1.2 Check install automatically give version of  "SonarQube Scanner 4.6.2.2472" (for other project)
                 1.4.3 Click apply and save 
           1.5 Run Pipeline job      
      
       
