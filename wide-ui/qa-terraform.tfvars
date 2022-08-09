prefix                              = "wideui-qa"
region                              = "eu-west-1"
vpc_id                              = "vpc-0f46725cf636bd696"             // Manual Update required */
vpc_cidr_range                      = "10.0.0.0/16"
iam_instance_profile                = "ssm-role1"
instance_type                        = "t2.small"
private_subnet_id                   = "subnet-01da78d121e4af2b4"
ingress_with_cidr_blocks_from_port1 = 80
ingress_with_cidr_blocks_to_port1   = 80
ingress_with_cidr_blocks_from_port2 = 443
ingress_with_cidr_blocks_to_port2   = 443
ingress_with_cidr_blocks_from_port3 = 22
ingress_with_cidr_blocks_to_port3   = 22
ingress_with_cidr_blocks_to_port4   = 5000
ingress_with_cidr_blocks_from_port4 = 5000


protocol                            = "tcp"
alb_listener_arn                    = "arn:aws:elasticloadbalancing:eu-west-1:901259681273:listener/app/wingd-dev-alb/de4a508844abd170/6d4fc4b4c33658c2"     // Manual Update required

source_security_group_id            ="sg-0bc17a07b2133e9b7"
