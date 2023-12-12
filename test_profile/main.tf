variable "aws_profile" {
  default = "default"
}

provider "aws" {
  profile = var.aws_profile
  region = "us-east-1"
}

resource "aws_instance" "example1" {
  ami           = "ami-0230bd60aa48260c6"  # Specify the AMI ID for your desired operating system
  instance_type = "t2.micro"  # Specify the instance type

  tags = {
    Name = "example-instance"  # Specify a name for your instance
  }
}


################S3_backend configuration######################
terraform {
  backend "s3" {
    bucket                  = "artifact1234"              // Manual Update required for: pass bucket name ad parameter which is already present in aws_account                                                          
    key                     = "key/terraform.tfstate"
    region                  = "us-east-1"
#    profile                 = env("aws_profile")                  // Manual Update required for: pass a profile parameter                                     
   shared_credentials_file = "~/.aws/credentials"
  }
}

terraform {
  backend "s3" {
    bucket                  = "wingd-tf-state-t3"                        
    key                     = "network/terraform.tfstate"
    region                  = "eu-west-1"                           
    shared_credentials_file = "~/.aws/credentials"
  }
}
