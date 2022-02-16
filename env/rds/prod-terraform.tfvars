prefix                             = "wingd-prod"
region                             = "eu-west-1"
engine_version                     = "5.7.19"
db_instance_class                  = "db.t2.medium"
db_allocated_storage               = "30"
db_username                        = "evt"
db_password                        = "SunLight#6"
db_port                            = "3306"
identifier                         = "rds-prod-mysql-evt"
private_subnet_ids                 = ["subnet-01da78d121e4af2b4", "subnet-0f7e9dcd3cc7c2a8b"]       // Manual Update required
vpc_cidr_block                     = "10.0.0.0/16"
vpc_id                             = "vpc-0f46725cf636bd696"                   // Manual Update required
ingress_with_cidr_blocks_from_port = 3306
ingress_with_cidr_blocks_to_port   = 3306
protocol                           = "tcp"
egress_with_cidr_blocks_from_port  = 0
egress_with_cidr_blocks_to_port    = 0
sg_engress_cidr_block              = "0.0.0.0/0"
max_allocated_storage              = 60

