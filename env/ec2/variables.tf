variable "prefix" {
  description = "Prefix name for each resource"
  default     = ""
}
variable "region" {
  description = "AWS Region the instance is launched in"
  default     = ""
}
variable "var.ingress_with_cidr_block1_from_port" {
  description = "port enable"
  type        =  number
}
variable "var.ingress_with_cidr_block1_to_port" {
  description = "port enable"
  type        =  number
}
variable "var.ingress_with_cidr_block2_to_port" {
  description = "port enable"
  type        =  number
}
variable "var.ingress_with_cidr_block2_from_port" {
  description = "port enable"
  type        =  number
}

variable "evt_instance_type" {
  description = "The type of evt instance to start"
  type        = string
}
variable "wideonline1_instance_type" {
  description = "The type of wideonline1 instance to start"
  type        = string
}
variable "wideonline2_instance_type" {
  description = "The type of wideonline2 instance to start"
  type        = string
}

variable "sizop_instance_type" {
  description = "The type of sizop instance to start"
  type        = string
}

variable "volume_size" {
  description = "The volume size for ec2"
  type        = number
}
variable "iam_instance_profile" {
  description = "A pre-defined profile to attach to the instance (default is to build our own)"
  type        = string
}

variable "subnet_id" {
  description = "private subnet id for ec2 instances"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC that the instance security group belongs to"
  type        = string
}

variable "vpc_cidr_range" {
  description = "VPC CIDR range for security group"
  type        = string
}
variable "public_subnets" {
  description = "A list of subnets to attach alb"
  type        = list(string)
}
