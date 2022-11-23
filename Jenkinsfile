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
		rm -rf /tmp/terraform
		mkdir /tmp/terraform
		cp ${WORKSPACE}/s3andcloudfront/cloudfront.tf /tmp/terraform
		cd /tmp/terraform
		terraform init
		terraform plan
		terraform apply -auto-approve
		bucket_name=$(terraform output --raw bucket_name)
		distribution-id=$(terraform output --raw cloudfront_id)
		'''
	}
    }

   stage ('copy the files to s3 bucket'){
      steps {
              sh'''
	      bucket_name=$(terraform output --raw bucket_name)
	      distribution-id=$(terraform output --raw cloudfront_id)
	      aws s3 cp /var/lib/jenkins/workspace/wideui/wideui-Frontend/auth/dist s3://$bucketname/auth/latest --recursive
	      aws cloudfront create-invalidation --distribution-id $distribution-id --paths "/auth/latest/remoteEntry.js"
	      aws s3 cp /var/lib/jenkins/workspace/wideui/wideui-Frontend/common/dist s3://$bucketname/common/latest --recursive
	      aws cloudfront create-invalidation --distribution-id $distribution-id --paths "/common/latest/remoteEntry.js"
	      aws s3 cp /var/lib/jenkins/workspace/wideui/wideui-Frontend/dashboard/dist s3://$bucketname/dashboard/latest --recursive
              aws cloudfront create-invalidation --distribution-id $distribution-id --paths "/dashboard/latest/remoteEntry.js"
	      aws s3 cp /var/lib/jenkins/workspace/wideui/wideui-Frontend/header/dist s3://$bucketname/header/latest --recursive
              aws cloudfront create-invalidation --distribution-id $distribution-id --paths "/header/latest/remoteEntry.js"
	      aws s3 cp /var/lib/jenkins/workspace/wideui/wideui-Frontend/webapp/dist s3://$bucketname/container/latest --recursive
              aws cloudfront create-invalidation --distribution-id $distribution-id --paths "/container/latest/remoteEntry.js"
	      '''

      }

   }


}

}

