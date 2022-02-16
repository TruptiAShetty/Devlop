prefix                             = "wingd-qa"
region                             = "eu-west-1"
##############vpc#####################
vpc_cidr                           = "10.0.0.0/16"

##############sonar_ec2##########
jenkins_ec2_instance_type           = "t2.medium"
jenkins_ec2_volume_size             = "30"
iam_instance_profile                = "ssm-ec2-role"
vpc_id                              = "vpc-0f9f2f2910f3ecbc3"         // Manual Update required
private_subnet_id                   = "subnet-047f6587b92aac1c0"     // Manual Update required
source_security_group_id            = "sg-0c8b1938dbc74448e"         // Manual Update required for: alb_security_group_id which we are going to launch a jenkins in alb
ingress_with_cidr_blocks_from_port  = 8080
ingress_with_cidr_blocks_to_port    = 8080
protocol                            = "tcp"
backend_protocol                    = "HTTP"
backend_port                        = 80
https_listeners_port                = 443
https_listeners_protocol            = "HTTPS"
sg_jenkins_ingress_rules            = ["https-443-tcp"]
alb_listener_arn                    = "arn:aws:elasticloadbalancing:eu-west-1:624603455002:listener/app/wingd-qa-alb/abae0bd1e0376ade/12853c154d317e3b"      // Manual Update required
