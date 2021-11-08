variable "region" {
  description = "AWS Region the instance is launched in"
  default     = ""
}

variable "vpc_cidr_block" {
   description = "VPC CIDR range for security group"
   type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC that the instance security group belongs to"
  type        = string
}
variable "prefix" {
  description = "Prefix name for each resource"
  default     = ""
}

variable "identifier" {
  description = "Prefix name for each resource"
  type        = string
}
variable "engine_version" {
  description = "The engine version to use in RDS"
  type        = string
}
variable "db_instance_class" {
  description = "The instance type for RDS instance"
  type        = string
}
variable "db_allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
}
variable "db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = null
}
variable "db_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "db_password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
}

variable "db_port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = 0
}

variable "db_multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}
variable "subnet_ids" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"

}
variable "ingress_with_cidr_blocks_from_port" {
   description = "enable port"
   type        = number
}
variable "ingress_with_cidr_blocks_to_port" {
   description = "enable port"
   type        = number
}
variable "protocol"{
   description = "protocol to be attached"
   type        = string
}


