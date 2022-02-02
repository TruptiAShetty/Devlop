prefix = "feedback-dev"
region = "eu-west-1"
##############vpc#####################
vpc_cidr               = "10.0.0.0/16"
azs                    = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
public_subnets         = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnets        = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
enable_nat_gateway     = true
single_nat_gateway     = true
one_nat_gateway_per_az = false
enable_dns_hostnames   = true
enable_dns_support     = true
bucket_name            = "vpc-dev-1234"




