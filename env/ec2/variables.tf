variable "prefix" {
  description = "Prefix name for each resource"
  default     = ""
}
variable "region" {
  description = "AWS Region the instance is launched in"
  default     = ""
}

variable "profile" {
  description = "profile for aws credentials"
  default     = ""
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
variable "protocol"{
   description = "protocol to be attached"
   type        = string
}


variable "backend_protocol"{
    description = "protocol to be attached to ALB"
    type        = string
}

variable "backend_port"{
    description = "protocol to be attached to ALB"
    type        = number
}
variable "https_listeners_port" {
    description = "https_listeners_port to be attached"
    type        = number 
}
variable "https_listeners_protocol" {
    description = "protocol to be attached"
    type        = string
}





