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




export AWS_ACCESS_KEY_ID="ASIAXKLGXJSQR3V7ZFNU"
export AWS_SECRET_ACCESS_KEY="/T4ECsovByjW2N6uo1+p/WBtJxzzLDfENPXxGaCJ"
export AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEG4aCWV1LXdlc3QtMSJHMEUCIQCMfwAHzIoYgj+sSpW1wn4W8C+HNIPtAuUwkRDSKns/uAIgUGP8jMPXzPq0cc7Awp5e4S7x5HFbmhCVw/R7PSY12PcqgAMI1///////////ARAAGgw1MDMyNjM0ODA5OTMiDKXXa7NrrTDIE/mypSrUAkLsmZeyNdZlmQOJ4qKfJz/5uWbDzZj+Ebd+zKOTAkaPC5uyXrH/gG9CIKmtBnbb0+L0piFhF9q68j1FWUwhmvOvBs3t6GyXAqPrGArjks4XCCgWsrQ3cEa/VxsMznvlVNkJyJY+vFFHOAJEKk4ldXgt06OhnqC/1OKRMrscVqerviJAWLrmdFjTy3WlLc6wlpRSztu2u5MBZeP9Q8I3i9sUf2hneHjIzlvmETdLsvI9RATAUtj2nzjsPRNdLYoMPnoeeR+/jO0/XOvh3UZK11q/7UnVsd3B91njULUSXoQD4dezPh0ku+PdSayLN8geWZMPbi5JziM7WRd//WjCVVMOFV+ogRI7ZZB2S8sMV3x9rpz7Nd73JXk4+Qxwb4Mmn49FYNRClCczqj1+jjXZCUJ20ixD6q66l6f04K/DxD5cLC2eVHv8VZqX3+UeM0nL+O89n5Awp9jRqwY6pwHUf46HQ7HUx13RqPNHdZX5sC2BJZcVhaYMlcuvvXfjf/vBSllRFu/GOXN5OJbfy6HHU1F+Wlz9v8o5qP1K5eygQx+cdVGFFT9lhnfDaLgfFPsat7TgmZWfzlSuCsZpcHzQA7QgpKRw55M17pdpXiDzCN7HajsVpQDfKFW4uEwKMzi6Pw2VK6JhZc18scPUAStoHEmQalQt1WzVVfVkMOwMYGXA9lJkpQ=="


[503263480993_AWSPowerUserAccess]
aws_access_key_id=ASIAXKLGXJSQ3V5UIJSM
aws_secret_access_key=NdAjVKe62Y+0caFV81rSUKr+hz1Q5BJmI2jY70EY
aws_session_token=IQoJb3JpZ2luX2VjEG4aCWV1LXdlc3QtMSJHMEUCIQDEfrhiunJRd8zSkCE9QyjJtqN9BUuTMZ+IJLRVuxIbvQIgJFEBVSBk0trnwsGOj8VNUpJOY/HIOuQclB0CCyN+ntMqgAMI1///////////ARAAGgw1MDMyNjM0ODA5OTMiDNP0b3Q2yid9+zYm5CrUAgjkTUuNe0MXy2rcTPSwcd9ZoWx0zEWei2+EZo62L7QCgQjqfTnzmcrzp/j8b9pB/jghFvFTMUiJVDRXk/knRxzKvh5lfaZdvlEVtWkGYJ0XqvW2CUF+Vj1nyfz76LFs3Ur4LQho2uLwTQ56CsUCKbJrdghPg3VxSrEKASeEyMOPHK/lkOdKot65N4ked2ce8fUg7mYkI4Vp0WnNgOoCbDI2uhHJjMp2c93eyBNnSkSUM8OKCp/z8npko08d2L0srCnBhHdstI6j0BRvyg1SqeTvJ4aHzZnIt5hUXIzETwk5lAPbJveMa/X/n/DNvTwUdd/NkeG4rHSHtTMCz60fq325NAfZsunz4my+F7s96hf/owMl4Q7atXZ2SXVWg9sLfposgAA8BTIT2G/ysrEBcWyTvwrE2ZaCmh25+DOJWJlJ4+vD5UO/v/DVnzCF5MvcShuTYLow0tjRqwY6pwEyksdPnnFK0s2rDaeLtFBwBYRBG0OCKAfbh1KsL1D1ESbsQ1FSbUR8VQdM8vxE01xkZ2+lN+vkp4+la93SeOrcHM5tUvDQ1YOjiDdmixJZ7uYUDHU+MD6WSrPFu4Mk/vD5Yuu5ok2L8NW3tbpDmDZp8C0b0eIXIs1hGc17GH7j+jRacUtRplPmxLTzc2P6yWfSwY5QeTThx9qG53+R7Gx11pdJgHd5YA==



[503263480993_AWSPowerUserAccess]
aws_access_key_id=ASIAXKLGXJSQQBWVSBYF
aws_secret_access_key=IpajrHTzuW6og1V58wIH/KbPbW/eFIMYjKCbsu9G
aws_session_token=IQoJb3JpZ2luX2VjEG4aCWV1LXdlc3QtMSJIMEYCIQCGGHlGY0OZqTanUFx+oV4fpRoK7FNkE4Ig2qhXioBcQgIhAMVzb0x9xcCeZFJ00XTvaKpCrmEaA0l06guVUn8YvXKRKoADCNf//////////wEQABoMNTAzMjYzNDgwOTkzIgyFRdpdfZflVUwPM8oq1AIa0hdmuaZ4R29HPrw8g9qDReQd7Ltr2VB0HjLVhOeep54aRURGRbFuFkKMuH7n2k3VDR5olhfWvThZN/Nv9F2JdqzHzUQWaHoEmy8wCZolssiBAidK/BF18wu7bf4Z8SM7wFTKQNgJ1I9jVjfzbaRbTIrE+xq9e8piyjmKLesWxNbQoXM/Q6JnASincEMK8eU7Ka6QJ5Jc2N89f2KGhv5L54He+bagDBDf+72abe/t4AKl9TwbJL4L4DRbszkVzmufbbk9vVq9hnsND8RS06GPA+p8ZBJQKVzHMmUbczvf7Hs2F+AkpmynrUWZEZEuo1bSMUVfNEndRXquuP+bC+ipoA57Spy3DIO6PBC/2cDBSYzSBWnflaB125LTPDvk191ieD4xvzOSt9bBndGBNMgBbe6CKDCO5nOy2gc6QXVnAKqtZk8A9JUkwR+dKwLG31LfudQSMMHZ0asGOqYBj855nWVOT8dyyEVDanlaOogzN2K+PZeoWTWZHdrB8P1hBYb+zD/2Q17OOY89fzvp08DKmK7Vhsqx37nkIrE3fdf2VgalTyZAEYPTyHP5er00snei1rIbLq9fuIJs/P6lSek+mT9UZy5aGGEwc53OQkgDFjHia9XnkA8aqvtwnz6ekWuwZk35kXygjtXiRYP+OcZoeFiCjwoiz4+/z2/IrbUB4qGtYQ==


QCFK-N451