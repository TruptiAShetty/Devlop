prefix                             = "wingd"
region                             = "eu-west-1"
##############vpc#####################
vpc_cidr                           = "10.0.0.0/16"

##############sonar_ec2##########
sonar_ec2_instance_type            = "t2.medium"
sonar_ec2_volume_size              = "30"
iam_instance_profile               = "ssm-role1"

vpc_id                             = "vpc-0f46725cf636bd696"
subnet_id                          = "subnet-01da78d121e4af2b4"

source_security_group_id           = "sg-0bc17a07b2133e9b7"


ingress_with_cidr_blocks_from_port  = 9000
ingress_with_cidr_blocks_to_port    = 9000
protocol                            = "tcp"

backend_protocol                    = "HTTP"
backend_port                        = 80
https_listeners_port                = 443
https_listeners_protocol            = "HTTPS"
sg_alb_ingress_rules                = ["http-80-tcp","https-443-tcp"]
sg_sonar_ingress_rules              = ["https-443-tcp"]
alb_arn                   = "arn:aws:elasticloadbalancing:eu-west-1:901259681273:loadbalancer/app/wingd-dev-alb/de4a508844abd170"
alb_listener_arn          = "arn:aws:elasticloadbalancing:eu-west-1:901259681273:listener/app/wingd-dev-alb/de4a508844abd170/6d4fc4b4c33658c2"


