pipeline{
  agent any

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
		echo $bucketname > $HOME/bname.txt
		sleep 1m
		distributionid=$(terraform output --raw cloudfront_id)
		echo $distributionid > $HOME/dname.txt
		'''
		}
	
	}
	}
    post {
      always {
          script {

	        echo 'post build action, triggering the wideui-frontend job which will build and deploy'
		build job: 'wideui-Frontend'
	        
          }

      }


   }
 
 }
