# Manual steps to deploy jenkins instance in private_subnet 
## Manual update require

- Private_subnet_id (created from env/vpc folder)
- vpc_id (created from env/vpc folder)
- source_security_group_id (we need to give security group id of the wingd-alb-sg)
- alb_arn(we need to gibe https:443 alb_arn)
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
         cd jenkins
- For the log file purpose please use the below commands

                      
             5.1 Windows:
		             $env:TF_LOG="TRACE"
			     $env:TF_LOG_PATH="terraform.txt" 
		    5.2 Linux:
		             export TF_LOG=TRACE
			     export TF_LOG_PATH="terraform.txt"
                
- Make sure the following `S3 Bucket`(wingd-tf-state) available in the AWS console.
        Note: Terraform stores information about your infrastructure in a state file. This state file keeps track of resources created by your configuration and maps them to real-world resources.
        

- Make sure create a role for the ssm in the aws account where we are going to excute the terraform script. while creation of the role take the policy of 'AmazonEC2RoleforSSM' & "AmazonSSMManagedInstanceCore" pass the role name to the `Iam_instance_profile` as a parametre in the terraform.tfvars.
- In the teraform script of main.tf change the profile parameter in which the s3 bucket has present.
- In the terraform script of main.tf change the `profile parameter,vpc_id,subnet_id,alb_listerner_arn & source_security_group_id` in terraform.tfvars & (added inline comment where have to change) in which the s3 bucket has present.
- Run the terraform init command which initiates the modules & versions 

                     
                    terraform init         
                    

- The terraform plan command evaluates a Terraform configuration to determine the desired state of all the resources it declares, then compares that desired state to the real infrastructure objects being managed with the current working directory and workspace.

                     terraform plan
- For the saving plan of terraform what are going to create we will use a command

                     terraform plan -out="tf.plan"
- After executing the above command we can see the file name "tf.plan" as been created . we will read the content of the tf.plan by using below command.

                     terraform show tf.plan 
- Terraform apply command is used to create or introduce changes to real infrastructure. By default, apply scans the current working directory for the configuration and applies the changes appropriately.

                     terraform apply

    Note: VPC networking, jenkins Ec2 instance in private subnet & Alb in public_subnet will be created
- After the creation of the resources. the file name "terraform.txt" will be create where all logs are present in terraform.txt
    16) After successful resources created.Access the Jenkins portal “https://jenkins.dev.wingd.digital"

- Configure aws credentials :

    Export the aws_access_key ,secrete_key & token 
                  Eg: export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                      export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                      export AWS_SESSION_TOKEN= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

- Run the below command for connecting to the jenkins instance.

            aws ssm start-session --target "instance-id"
         
	Note: instance-id = which is created by terraform script (wingd-jenkins)

- Read the file initial password of Jenkins.

        "sudo cat /var/lib/Jenkins/secrets/initialAdminPassword"
- Copy and paste the initialAdminPassword to the jenkins page and proceed to complete the jenkins installation.
- After the creation of the resources we can clean by using the command.

                    terraform destroy
