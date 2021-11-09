prefix                              = "wingd"
region                              = "eu-west-1"
evt_instance_type                   = "t3.small"
sizop_instance_type                 = "t2.small"
wideonline1_instance_type           = "t3.medium"
wideonline2_instance_type           = "t3.medium"
subnet_id                           = "subnet-0ea3b3612f410970d"
vpc_id                              = "vpc-0f46725cf636bd696"
vpc_cidr_range                      = "10.0.0.0/16"
iam_instance_profile                = "ssm-role1"
volume_size                         = 30
public_subnets                      = ["subnet-0192fcf75eb938a9a", "subnet-0e98b4b49d56f3ba3"]
ingress_with_cidr_blocks_from_port1 = 80
ingress_with_cidr_blocks_to_port1   = 80
ingress_with_cidr_blocks_from_port2 = 22
ingress_with_cidr_blocks_to_port2   = 22
protocol                            = "tcp"
backend_protocol                    = "HTTP"
backend_port                        = 80
https_listeners_port                = 443
https_listeners_protocol            = "HTTPS"
sg_alb_ingress_rules                = ["http-80-tcp","https-443-tcp"]
