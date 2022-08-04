variable "prefix" {
  description = "Prefix name for each resource"
  default     = ""
}
variable "region" {
  description = "AWS Region the instance is launched in"
  default     = ""
}

variable "instance_type" {
  description = "The type of evt instance to start"
  type        = string
}

variable "iam_instance_profile" {
  description = "A pre-defined profile to attach to the instance (default is to build our own)"
  type        = string
}

variable "private_subnet_id" {
  description = "private subnet id for ec2 instances"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC that the instance security group belongs to"
  default = "vpc-0f46725cf636bd696"
}

variable "vpc_cidr_range" {
  description = "VPC CIDR range for security group"
  type        = string
}

variable "ingress_with_cidr_blocks_from_port1" {
   description = "enable port"
   type        = number
}
variable "ingress_with_cidr_blocks_to_port1" {
   description = "enable port"
   type        = number
}
variable "ingress_with_cidr_blocks_from_port2" {
   description = "enable port"
   type        = number
}
variable "ingress_with_cidr_blocks_to_port2" {
   description = "enable port"
   type        = number
}
variable "ingress_with_cidr_blocks_from_port3" {
   description = "enable port"
   type        = number
}
variable "ingress_with_cidr_blocks_to_port3" {
   description = "enable port"
   type        = number
}
variable "ingress_with_cidr_blocks_from_port4" {
   description = "enable port"
   type        = number
}
variable "ingress_with_cidr_blocks_to_port4" {
   description = "enable port"
   type        = number
}

variable "protocol"{
   description = "protocol to be attached"
   type        = string
}



variable "alb_listener_arn" {
  description = "A pre-defined alb_listener to attach to the alb"
  type        = string
}

variable "source_security_group_id" {
   description ="port security group id come from wingd-env-alb"
   type        = string
}
variable "security_group_id" {
   description ="port is going to add to the security group id for wingd-env-alb"
   type        = string
}
