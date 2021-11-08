provider "aws" {
  profile                 = "default"
  shared_credentials_file = pathexpand("~/.aws/credentials")
  region                  = var.region
}
# creation of RDS security_group
module "rds_sg" {
  source = "../../modules/security_group"
  name   = "${var.prefix}-${terraform.workspace}-rds-sg"
  vpc_id = var.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = var.ingress_with_cidr_blocks_from_port
      to_port     = var.ingress_with_cidr_blocks_to_port
      protocol    = var.protocol
      description = "MySQL access from within VPC"
      cidr_blocks = var.vpc_cidr_block
    },
  ]
  egress_rules = ["all-all"]
}
# creation of RDS_MYSQL
module "db" {
  source                                = "../../modules/rds"
  identifier                            = var.identifier
  engine                                = "mysql"
  engine_version                        = var.engine_version
  instance_class                        = var.db_instance_class
  create_db_option_group                = false
  create_db_parameter_group             = false
  allocated_storage                     = var.db_allocated_storage
  storage_encrypted                     = true
  username                              = var.db_username
  password                              = var.db_password
  port                                  = var.db_port
  name                                  = "${var.prefix}_rds"
  multi_az                              = var.db_multi_az
  subnet_ids                            = var.subnet_ids
  vpc_security_group_ids                = [module.rds_sg.security_group_id]
  enabled_cloudwatch_logs_exports       = ["general"]
  backup_retention_period               = 0
  skip_final_snapshot                   = true
  deletion_protection                   = true
  performance_insights_retention_period = 7
  create_monitoring_role                = false
# monitoring_role_name                  = "${var.prefix}-rds-monitor-role"
# monitoring_interval                   = 30
}
# S3_backend configuration
terraform {
  backend "s3" {
    bucket                  = "wingd-tf-state"
    key                     = "rds/terraform.tfstate"
    region                  = "eu-west-1"
    profile                 = "default"
    shared_credentials_file = "~/.aws/credentials"
  }
}
