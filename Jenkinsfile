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
		cp ${WORKSPACE}/s3andcloudfront/* ${WORKSPACE}/terraform
		cd ${WORKSPACE}/terraform
		terraform init
	        terraform plan -var-file dev.tfvars -out dev.out
		terraform apply -auto-approve dev.out
		'''
		}
	
	}
	}
 
 }
