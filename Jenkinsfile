pipeline{
  agent any

  stages {
    stage ('SCM Checkout') {
    	steps {
	 git branch: 'development', credentialsId: 'rahamat-git-credentials', url: 'https://gitlab.wingd.com/wide2/aws_infra_terraform.git'
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
		bucketname=$(terraform output --raw bucket_name)
		echo $bucketname > $HOME/bname.txt
		sleep 1m
		distributionid=$(terraform output --raw cloudfront_id)
		echo $distributionid > $HOME/dname.txt
		aws s3 cp ${WORKSPACE}/terraform/terraform.tfstate s3://wideui-tf-state/s3andcloudfront/terraform.tfstate
		aws s3 cp ${HOME}/bname.txt s3://wideui-tf-state/s3andcloudfront/
		aws s3 cp ${HOME}/dname.txt s3://wideui-tf-state/s3andcloudfront/
		'''
		}
	
	}
	}
 
 }
