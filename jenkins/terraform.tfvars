prefix = "wingd"
region = "eu-west-1"
##############vpc#####################
vpc_cidr               = "10.0.0.0/16"
azs                    = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
#azs                    = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnets         = ["10.0.0.0/24", "10.0.1.0/24",]
private_subnets        = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
enable_nat_gateway     = true
single_nat_gateway     = true
one_nat_gateway_per_az = false
enable_dns_hostnames   = true
enable_dns_support     = true

##############jenkins_ec2##########
jenkins_ec2_instance_type = "t2.medium"
jenkins_ec2_volume_size   = "20"
iam_instance_profile      = "ssm-role1"


###############jenkins security_group########
ingress_with_cidr_blocks_from_port  = 8080
ingress_with_cidr_blocks_to_port    = 8080

protocol                            = "tcp"
egress_with_cidr_blocks_from_port = 0
egress_with_cidr_blocks_to_port   = 0
backend_protocol             = "HTTP"
backend_port                 = 80
https_listeners_port         = 443
https_listeners_protocol     = "HTTPS"
sg_alb_ingress_rules         = ["http-80-tcp","https-443-tcp"]
sg_jenkins_ingress_rules     = ["https-443-tcp"]
alb_sg_ingress_from_port1    = 80
alb_sg_ingress_to_port1      = 80
alb_sg_ingress_to_port2      = 443
alb_sg_ingress_from_port2    = 443
certificate_arn              = "arn:aws:acm:eu-west-1:901259681273:certificate/3f404b71-f1a1-4b8f-9c82-4dd062fc9e16"



bucket_name              = "vpc-aws-logs-1789"
bucket_name_1             = "wingd-elb-2yuuj77"
sg_engress_cidr_block     = "0.0.0.0/0"

