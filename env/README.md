Steps for the creation of Environment infrastructure Dev,QA & Prod
    
    1) install terraform plugin
          1.1 First we need to install terraform plugin Goto manage jenkins under (Jenkins’s header) <manage plugins> and then select avaliable.Type terraform in search and install without restart.
    2) Configure global tool
          2.1 First, we need set up the global tool configuration under (Jenkins’s header) <Manage Jenkins > Global Tool Configuration.
          2.2 Now in this page configure terraform.
    3) Creating a folder for Dev_infra 
          3.1 Now go to Jenkins’s dashboard page by clicking “Jenkins” under the header and click on “New  Item” from the left menu panel.
          3.2 Enter your Folder name Dev_infra name and select folder and then click ok & save 
          3.3 Inside the folder Creating a Jenkins job1 for dev_ec2 
                      3.3.1 Now go to Jenkins’s dashboard page by clicking “Jenkins” under the header and click on “New  Item” from the left menu panel.
                      3.3.2 Enter your Jenkins job name and select pipeline project (As we are using pipeline project, you can select as per your project type) and then click on “OK”.
                      3.3.3 Now you must configure your Jenkins job. First under General section check “This project is parameterized” option and then select String Parameter option by clicking the “Add Parameter” button.
                               [NOTE parameters AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY & AWS_SESSION_TOKEN]
                      3.3.4 Then write the pipeline and click save
                      3.3.5 Run the job with bulid with parameters give the values for the string parameters.
                      3.3.6 After bulid success the creation of the dev_ec2 4 instances will be created(sizop,evt,wideonline1 & wideonline2)
          3.4 Inside the folder Creating a Jenkins job1 for dev_rds 
                      3.4.1 Now go to Jenkins’s dashboard page by clicking “Jenkins” under the header and click on “New  Item” from the left menu panel.
                      3.4.2 Enter your Jenkins job name and select pipeline project (As we are using pipeline project, you can select as per your project type) and then click on “OK”.
                      3.4.3 Now you must configure your Jenkins job. First under General section check “This project is parameterized” option and then select String Parameter option by clicking the “Add Parameter” button.
                               [NOTE parameters AWS_ACCESS_KEY_ID,AWS_SECRET_ACCESS_KEY & AWS_SESSION_TOKEN]
                      3.4.4 Then write the pipeline and click save
                      3.4.5 Run the job with bulid with parameters give the values for the string parameters.
                      3.4.6 After bulid success the creation of the rds will taken place 
  

  





     
