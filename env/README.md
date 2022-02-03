# Steps for Infra deploy through jenkinspipeline
## Steps for the creation of DEV infrastructure,

-  For the creation of dev_infra we have to create 2 pipeline 

- `pipeline 1` : for the creation of 4 ec2 & ALB in public subnet`.  
- `pipeline 2` : for the creation of rds in dev environment.
- Access the jenkins portal "https://jenkins.dev.wingd.digital" - use the login credentials of jenkins (username & password) it is dependent on README.md step 13(https://gitlab.wingd.com/wide2/aws_infra_terraform/-/tree/terraform_scripts/jenkins)
- **Creating a folder for `Dev` infra**
- Now go to Jenkins’s dashboard on `New Item` from the left menu panel.
- Enter your Folder name Dev_infra name and select folder and then click ok & save
- Inside the folder Create a Jenkins pipeline1 for dev_ec2
- click on “New  Item” from the left menu panel.
- Enter your Jenkins job name and select pipeline project and then click on “OK”.
- Now you must configure your Jenkins job. First under General section check `This project is parameterized` option and then select String Parameter option by clicking the “Add Parameter” button and add parameters `AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY & AWS_SESSION_TOKEN`                      
- Then write the pipeline and click save
- Run the job build with parameters give the values `AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY & AWS_SESSION_TOKEN` .
- The creation of 4 ec2 in private subnet & one ALB will be taken place before the build success.
- Inside the folder Create a Jenkins pipeline2 for dev_rds
- click on “New  Item” from the left menu panel.
- Enter your Jenkins job name and select pipeline project and then click on “OK”.
- Now you must configure your Jenkins job. First under General section check “This project is parameterized” option and then select String Parameter option by clicking the “Add Parameter” button and parameters `AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY & AWS_SESSION_TOKEN`.
- Then write the pipeline and click save(which is present int the env/ec2 & env/vpc folder)
- Run the job build with parameters give the values of `AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY & AWS_SESSION_TOKEN` 
- The creation of rds will be taken place before the build success.
- For the cleaning of resources after creation using command 
                 terraform destroy -var-file dev-terraform.tfvars
- **Steps for the creation of `QA` infrastructure**

- The creation of QA infrastructure as follows same steps for the dev_infra.Create a folder name Qa_infra.
- inside the folder,Create a job1 qa_ec2 & job2 qa_rds.
- For the cleaning of resources after creation using command

                 terraform destroy -var-file qa-terraform.tfvars

- **Steps for the creation of PROD infrastructure**

- The creation of PROD infrastructure as follows same steps for the dev_infra.Create a folder name Prod_infra.
- inside the folder,Create a job1 prod_ec2 & job2 prod_rds.
- For the cleaning of resources after creation using command

	   terraform destroy -var-file prod-terraform.tfvars

  





     
