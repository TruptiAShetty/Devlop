prefix                              = "wingd-qa"						// Manual Update required
region                              = "eu-west-1"
evt_instance_type                   = "t3.small"
sizop_instance_type                 = "t2.small"
wideonline1_instance_type           = "t3.medium"
wideonline2_instance_type           = "t3.medium"
private_subnet_id                   = "subnet-0b27de34a804c0859"        // Manual Update required
vpc_id                              = "vpc-0c2fde13cf5af2a67"           // Manual Update required
vpc_cidr_range                      = "10.0.0.0/16"
iam_instance_profile                = "ssm-ec2-role"					// Manual Update required
volume_size                         = 30
public_subnets                      = ["subnet-08e5b21aa0c35c890", "subnet-08b93304e1f050484"]      // Manual Update required
ingress_with_cidr_blocks_from_port1 = 80
ingress_with_cidr_blocks_to_port1   = 80
ingress_with_cidr_blocks_from_port2 = 443
ingress_with_cidr_blocks_to_port2   = 443
ingress_with_cidr_blocks_from_port3 = 22
ingress_with_cidr_blocks_to_port3   = 22
protocol                            = "tcp"
backend_protocol                    = "HTTP"
backend_port                        = 80
https_listeners_port                = 443
https_listeners_protocol            = "HTTPS"
sg_alb_ingress_rules                = ["http-80-tcp","https-443-tcp"]
certificate_arn                     = "arn:aws:acm:eu-west-1:624603455002:certificate/1ca8a5aa-d6bb-41ea-858b-5de58eea61f9"     // Manual Update required
subnet_vpc_endpoint                 = ["subnet-0c8154c5105a61d36"]      // Manual Update required

bucket_name_1                       = "wingd-elb-qa-67865"				// Manual Update required
