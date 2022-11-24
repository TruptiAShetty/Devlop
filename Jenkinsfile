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
		bucketname=$(terraform output --raw bucket_name)
		sleep 2m
		distributionid=$(terraform output --raw cloudfront_id)
		'''
	}
    }

   stage ('copy the files to s3 bucket'){
      steps {
              sh'''
	      aws s3 cp /var/lib/jenkins/workspace/wideui/wideui-Frontend/auth/dist s3://$bucketname/auth/latest --recursive
	      aws cloudfront create-invalidation --distribution-id $distributionid --paths "/auth/latest/remoteEntry.js"
	      aws s3 cp /var/lib/jenkins/workspace/wideui/wideui-Frontend/common/dist s3://$bucketname/common/latest --recursive
	      aws cloudfront create-invalidation --distribution-id $distributionid --paths "/common/latest/remoteEntry.js"
	      aws s3 cp /var/lib/jenkins/workspace/wideui/wideui-Frontend/dashboard/dist s3://$bucketname/dashboard/latest --recursive
              aws cloudfront create-invalidation --distribution-id $distributionid --paths "/dashboard/latest/remoteEntry.js"
	      aws s3 cp /var/lib/jenkins/workspace/wideui/wideui-Frontend/header/dist s3://$bucketname/header/latest --recursive
              aws cloudfront create-invalidation --distribution-id $distributionid --paths "/header/latest/remoteEntry.js"
	      aws s3 cp /var/lib/jenkins/workspace/wideui/wideui-Frontend/webapp/dist s3://$bucketname/container/latest --recursive
              aws cloudfront create-invalidation --distribution-id $distributionid --paths "/container/latest/remoteEntry.js"
	      '''

      }

   }


}

}

