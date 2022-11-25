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
		mkdir terraform
		cp ${WORKSPACE}/s3andcloudfront/cloudfront.tf ${WORKSPACE}/terraform
		cd ${WORKSPACE}/terraform
		terraform init
		terraform plan -out wideuife.out 
		terraform apply -auto-approve wideuife.out 
		bucketname=$(terraform output --raw bucket_name)
		sleep 2m
		distributionid=$(terraform output --raw cloudfront_id)
		'''
	}
    }

    stage ('Deployind Auth changes'){
	steps {
		sh '''
		cd ${WORKSPACE}/packages/auth/
		npm install -y
		npm run test:report
		npm run build:dev
	        cd ${WORKSPACE}/terraform
		bucketname=$(terraform output --raw bucket_name)
		distributionid=$(terraform output --raw cloudfront_id)
		aws s3 cp ${WORKSPACE}/packages/auth/dist s3://$bucketname/auth/latest --recursive
		aws cloudfront create-invalidation --distribution-id $distributionid --paths "/auth/latest/remoteEntry.js"
		npm run sonar:dev
		'''
	}
    }
    stage ('Common Changes'){
	steps {
		sh '''
		cd ${WORKSPACE}/packages/common/
                npm install -y
                npm run build:dev
		cd ${WORKSPACE}/terraform
                bucketname=$(terraform output --raw bucket_name)
                distributionid=$(terraform output --raw cloudfront_id)
                aws s3 cp ${WORKSPACE}/packages/common/dist s3://$bucketname/common/latest --recursive
                aws cloudfront create-invalidation --distribution-id $distributionid --paths "/common/latest/remoteEntry.js"
		'''
	}
    }
    stage ('Dashboard Changes'){
        steps {
                sh '''
                cd ${WORKSPACE}/packages/dashboard/
                npm install -y
                npm run build:dev
		cd ${WORKSPACE}/terraform
                bucketname=$(terraform output --raw bucket_name)
                distributionid=$(terraform output --raw cloudfront_id)
                aws s3 cp ${WORKSPACE}/packages/dashboard/dist s3://$bucketname/dashboard/latest --recursive
                aws cloudfront create-invalidation --distribution-id $distributionid --paths "/dashboard/latest/remoteEntry.js"
		'''

        }
    }
    stage ('Header Changes'){
        steps {
                sh '''
                cd ${WORKSPACE}/packages/header/
                npm install -y
                npm run test:report
                npm run build:dev
		cd ${WORKSPACE}/terraform
                bucketname=$(terraform output --raw bucket_name)
                distributionid=$(terraform output --raw cloudfront_id)
                aws s3 cp ${WORKSPACE}/packages/header/dist s3://$bucketname/header/latest --recursive
                aws cloudfront create-invalidation --distribution-id $distributionid --paths "/header/latest/remoteEntry.js"
                npm run sonar:dev
		'''
        }
    }

    stage ('Webapp Changes'){
        steps {
                sh '''
                cd ${WORKSPACE}/packages/webapp/
                npm install -y
                npm run test:report
		sudo rm -rf dist
                npm run build:dev
		cd ${WORKSPACE}/terraform
                bucketname=$(terraform output --raw bucket_name)
                distributionid=$(terraform output --raw cloudfront_id)
                aws s3 cp ${WORKSPACE}/packages/webapp/dist s3://$bucketname/container/latest --recursive
                aws cloudfront create-invalidation --distribution-id $distributionid --paths "/container/latest/remoteEntry.js"
                npm run sonar:dev
		'''
        }
    }


   stage ('Remove existing docker images') {
     steps {
            sh '''#!/bin/bash
	    cd ${WORKSPACE}/docker/
    	    docker-compose down
    	    docker-compose -p wideui down
    	    docker system prune --force --all'''
     }
   }
   stage ('Build docker tar file'){
	 steps {
		   sh '''#!/bin/bash
    		   cd ${WORKSPACE}/packages/webapp
    		   npm install -y
    		   sudo usermod -a -G docker $USER && npm run docker'''
		   }
       	}
   stage ('upload docker tar file to s3'){
	 steps {
		sh '''#!/bin/bash
    		aws s3 sync s3://docker-mfe/docker-images . --delete
    		aws s3 cp ${WORKSPACE}/packages/webapp/dist-docker-images/ s3://docker-mfe/docker-images --exclude "*" --include "*.zip"'''
		}
	}


    }

}

