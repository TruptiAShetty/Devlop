prefix                              = "feedback-dev"
region                              = "eu-west-1"
evt_instance_type                   = "t3.small"
sizop_instance_type                 = "t2.small"
wideonline1_instance_type           = "t3.medium"
wideonline2_instance_type           = "t3.medium"
private_subnet_id                   = "subnet-0b76f9ef2f7c99226"
vpc_id                              = "vpc-06d7a33bee86e1d13"
vpc_cidr_range                      = "10.0.0.0/16"
iam_instance_profile                = "ssm-role1"
volume_size                         = 30
public_subnets                      = ["subnet-060e99623922a5d7a", "subnet-0d98fa29b525f64de"]
ingress_with_cidr_blocks_from_port1 = 80
ingress_with_cidr_blocks_to_port1   = 80
ingress_with_cidr_blocks_from_port2 = 443
ingress_with_cidr_blocks_to_port2   = 443
protocol                            = "tcp"
backend_protocol                    = "HTTP"
backend_port                        = 80
https_listeners_port                = 443
https_listeners_protocol            = "HTTPS"
sg_alb_ingress_rules                = ["http-80-tcp","https-443-tcp"]
certificate_arn                     = "arn:aws:acm:eu-west-1:901259681273:certificate/3f404b71-f1a1-4b8f-9c82-4dd062fc9e16"
private_subnet_ids                  = ["subnet-0b76f9ef2f7c99226"]
bucket_name_1                       = "wingd-elb-dev-567y"
