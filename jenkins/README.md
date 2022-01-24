Steps:

    1) Local machine setup:
        1.1) terraform required.(terraform version = 1.0.7)
          Installation guide:
          https://www.terraform.io/docs/cli/install/apt.html
        1.2) git required.
	      Installation guide:
	      https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
        1.3) awscli required.(awscli version = 1.18.69 )
          Installation guide:
          https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
        1.4) SSM plugin to be installed
           Installation guide:
           https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-debian
		
    2)  Configure aws credentials : 
                     Export the aws_access_key ,secrete_key & token 
                      Eg: export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                          export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                          export AWS_SESSION_TOKEN= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    3)  GIT: 
          git clone "https://www.wingd.com/gitlab/wide2/aws_infra_terraform"  
    4)  Goto jenkins folder
         cd jenkins
    5)  For the log file purpose please use the below commands
                      5.1 Windows:
		             $env:TF_LOG="TRACE"
			     $env:TF_LOG_PATH="terraform.txt" 
		          5.2 Linux:
		             export TF_LOG=TRACE
			     export TF_LOG_PATH="terraform.txt"
    6)  Make sure the following S3 Bucket(wingd-tf-state) available in the AWS console.
        Note: Terraform stores information about your infrastructure in a state file. This state file keeps track of resources created by your configuration and maps them to real-world resources.
    7)  Make sure create a role for the ssm in the aws account where we are going to excute the terraform script. while creation of the role take the policy of "AmazonEC2RoleforSSM" & "AmazonSSMManagedInstanceCore" pass the role name to the "Iam_instance_profile" as a parametre in the terraform.tfvars.
    8)  In the teraform script of main.tf change the profile parameter in which the s3 bucket has present.
    9)  Make sure the SSl certificate is present in AWS_account in which infra is going to deploy because in main.tf "https_listeners" we are passing certificate_arn as a parameter
    10) Run the terraform init command which initiates the modules & versions 
                     terraform init
    11) The terraform plan command evaluates a Terraform configuration to determine the desired state of all the resources it declares, then compares that desired state to the real infrastructure objects being managed with the current working directory and workspace.
                     terraform plan
    12) For the saving plan of terraform what are going to create we will use a command
                     terraform plan -out="tf.plan"
    13) after executing the above command we can see the file name "tf.plan" as been created . we will read the content of the tf.plan by using below command.
                     terraform show tf.plan 
    14) Terraform apply command is used to create or introduce changes to real infrastructure. By default, apply scans the current working directory for the configuration and applies the changes appropriately.
                     terraform apply
        Note: VPC networking, jenkins Ec2 instance in private subnet & Alb in public_subnet will be created
    15) After the creation of the resources. the file name "terraform.txt" will be create where all logs are present in terraform.txt
    16) After successful resources created.Access the Jenkins portal “https://:ALBendpoind:80"
    17) Configure aws credentials : 
                 Export the aws_access_key ,secrete_key & token 
                  Eg: export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                      export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
                      export AWS_SESSION_TOKEN= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

    18) Run the below command for connecting to the jenkins instance.
            aws ssm start-session --target "instance-id" 
	    Note: instance-id = which is created by terraform script (wingd-jenkins)
    19) Read the file initial password of Jenkins.
        "sudo cat /var/lib/Jenkins/secrets/initialAdminPassword"
    20) Copy and paste the initialAdminPassword to the jenkins page and proceed to complete the jenkins installation.
    21) After the creation of the resources we can clean by using the command.
                    terraform destroy
