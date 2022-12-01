
pipeline{
  agent any;
  environment {

  	bucketname=""
	distributionid=""


  }
  stages {
    stage ('SCM Checkout') {
    	steps {
	 git branch: 'development', credentialsId: 'rahamat-git-credentials', url: 'https://gitlab.wingd.com/wide2/aws_infra_terraform.git'
	 dir ('wideui-fe'){ 
	       git branch: 'development', credentialsId: 'rahamat-git-credentials', url: 'https://gitlab.wingd.com/wide2/wideui.git'
	       }
	}
      }
    
    stage ('run terraform script'){ 
	steps {
		sh'''
		cd ${WORKSPACE}
		mkdir -p terraform
		cp ${WORKSPACE}/s3andcloudfront/cloudfront.tf ${WORKSPACE}/terraform
		cd ${WORKSPACE}/terraform
		terraform init
		terraform plan -out wideuife.out 
		terraform apply -auto-approve wideuife.out 
		bucketname=$(terraform output --raw bucket_name)
		sleep 2m
		distributionid=$(terraform output --raw cloudfront_id)
		'''
		script {
		    cd ${WORKSPACE}/terraform
		    build job: 'wideui-Frontend'
		    def bucketname = sh(script: 'terraform output --raw bucket_name', returnstdout: true)
		    print bucketname
		    def distributionid =  sh(script: 'terraform output --raw cloudfront_id', returnstdout: true)
		    print distributionid
		    parameters:[[$class: 'StringParamaterValue', name: 'distributionId', value: 'env.distributionid'], [$class: 'StringParameterValue', name: 'bucketName', value: 'env.bucketname']]


		}
	}
    }
   }

}
