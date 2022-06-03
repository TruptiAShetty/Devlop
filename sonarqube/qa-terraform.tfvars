prefix                             = "wingd-qa"
region                             = "eu-west-1"
##############vpc#####################
vpc_cidr                           = "10.0.0.0/16"

##############sonar_ec2##########
sonar_ec2_instance_type            = "t2.medium"
sonar_ec2_volume_size              = "30"
iam_instance_profile               = "ssm-ec2-role"

vpc_id                             = "vpc-0c2fde13cf5af2a67"                // Manual Update required
private_subnet_id                  = "subnet-0b27de34a804c0859"             // Manual Update required

source_security_group_id           = "sg-03f482afc00826697"                // Manual Update required for: alb_security_group_id which we are going to launch a sonarqube in alb


ingress_with_cidr_blocks_from_port  = 9000
ingress_with_cidr_blocks_to_port    = 9000
protocol                            = "tcp"

backend_protocol                    = "HTTP"
backend_port                        = 80
https_listeners_port                = 443
https_listeners_protocol            = "HTTPS"
sg_sonar_ingress_rules              = ["https-443-tcp"]
alb_listener_arn                    = "arn:aws:elasticloadbalancing:eu-west-1:624603455002:listener/app/wingd-qa-alb/b1053e9ec2fd924e/665327ddf40034c2"      // Manual Update required


