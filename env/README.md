A) Steps for the creation of DEV infrastructure,

      1) For the creation of dev_infra we have to create 2 pipeline 
              pipeline 1 : for the creation of 4 ec2 & ALB in public subnet.  
              pipeline 2 : for the creation of rds in dev environment.
      2) Access the jenkins portal "https://ALBendpoind:80
      3) use the login credentials of jenkins (username & password) it is dependent on README.md step 13(https://gitlab.wingd.com/wide2/aws_infra_terraform/-/tree/terraform_scripts/jenkins)
      4) Creating a folder for Dev_infra
              4.1 Now go to Jenkins’s dashboard on “New Item” from the left menu panel.
              4.2 Enter your Folder name Dev_infra name and select folder and then click ok & save
              4.3 Inside the folder Create a Jenkins pipeline1 for dev_ec2
                      4.3.1 click on “New  Item” from the left menu panel.
                      4.3.2 Enter your Jenkins job name and select pipeline project and then click on “OK”.
                      4.3.3 Now you must configure your Jenkins job. First under General section check “This project is parameterized” option and then select String Parameter option by clicking the “Add Parameter” button and add parameters AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY & AWS_SESSION_TOKEN                      
                      4.3.4 Then write the pipeline and click save
                      4.3.5 Run the job bulid with parameters give the values AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY & AWS_SESSION_TOKEN .
                      4.3.6 The creation of 4 ec2 in private subnet & one ALB will be taken place before the bulid success.
              4.4 Inside the folder Create a Jenkins job2 for dev_rds
                      4.4.1 click on “New  Item” from the left menu panel.
                      4.4.2 Enter your Jenkins job name and select pipeline project and then click on “OK”.
                      4.4.3 Now you must configure your Jenkins job. First under General section check “This project is parameterized” option and then select String Parameter option by clicking the “Add Parameter” button and parameters AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY & AWS_SESSION_TOKEN.
                      4.4.4 Then write the pipeline and click save
                      4.4.5 Run the job bulid with parameters give the values of AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY & AWS_SESSION_TOKEN 
                      4.4.6 The creation of rds will be taken place before the bulid success.

B) Steps for the creation of QA infrastructure,
       1)The creation of QA infrastructure as follows same steps for the dev_infra.Create a folder name Qa_infra.
       2) inside the folder,Create a job1 qa_ec2 & job2 qa_rds.

c) Steps for the creation of PROD infrastructure,
       1)The creation of PROD infrastructure as follows same steps for the dev_infra.Create a folder name Prod_infra.
       2) inside the folder,Create a job1 prod_ec2 & job2 prod_rds.


  





     
