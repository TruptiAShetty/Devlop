#variable "aws_profile" {
  #default = "default"
#}

provider "aws" {
  profile = "503263480993_AWSPowerUserAccess"
  region = "eu-west-1"
}

resource "aws_instance" "example1" {
  ami           = "ami-07355fe79b493752d"  # Specify the AMI ID for your desired operating system
  instance_type = "t2.micro"  # Specify the instance type

  tags = {
    Name = "example-instance"  # Specify a name for your instance
  }
}


################S3_backend configuration######################
terraform {
  backend "s3" {
    bucket                  = "wingd-tf-state-t6"              // Manual Update required for: pass bucket name ad parameter which is already present in aws_account                                                          
    key                     = "profile/terraform.tfstate"
    region                  = "eu-west-1"                 // Manual Update required for: pass a profile parameter                                     
   shared_credentials_file = "~/.aws/credentials"
  }
}
