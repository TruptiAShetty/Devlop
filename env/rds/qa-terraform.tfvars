prefix                             = "wingd-qa"
region                             = "eu-west-1"
engine_version                     = "5.7.19"
db_instance_class                  = "db.t2.small"
db_allocated_storage               = "30"
db_username                        = "evt"
db_password                        = "SunLight#6"
db_port                            = "3306"
identifier                         = "rds-qa-mysql-evt"
private_subnet_ids                 = ["subnet-0b27de34a804c0859", "subnet-063d898c18b79fa79"]       // Manual Update required
vpc_cidr_block                     = "10.0.0.0/16"
vpc_id                             = "vpc-0c2fde13cf5af2a67"        // Manual Update required
ingress_with_cidr_blocks_from_port = 3306
ingress_with_cidr_blocks_to_port   = 3306
protocol                           = "tcp"
egress_with_cidr_blocks_from_port  = 0
egress_with_cidr_blocks_to_port    = 0
sg_engress_cidr_block              = "0.0.0.0/0"
max_allocated_storage              = 60

