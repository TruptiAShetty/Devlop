prefix                             = "wingd-dev"
region                             = "eu-west-1"
##############vpc#####################
vpc_cidr                           = "10.0.0.0/16"

##############sonar_ec2##########
jenkins_ec2_instance_type           = "t2.medium"
jenkins_ec2_volume_size             = "30"
iam_instance_profile                = "ssm-role1"
vpc_id                              = "	vpc-0f46725cf636bd696"       // Manual Update required
private_subnet_id                   = "subnet-01da78d121e4af2b4"    // Manual Update required
source_security_group_id            = "sg-0e958b42bd463ce07"        // Manual Update required for: alb_security_group_id which we are going to launch a jenkins in alb
ingress_with_cidr_blocks_from_port  = 8080
ingress_with_cidr_blocks_to_port    = 8080
protocol                            = "tcp"
backend_protocol                    = "HTTP"
backend_port                        = 80
https_listeners_port                = 443
https_listeners_protocol            = "HTTPS"
sg_jenkins_ingress_rules            = ["https-443-tcp"]
alb_listener_arn                    = "arn:aws:elasticloadbalancing:eu-west-1:901259681273:loadbalancer/app/wingd-dev-alb/de4a508844abd170"        // Manual Update required


