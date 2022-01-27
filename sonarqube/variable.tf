variable "prefix" {
  description = "Prefix name for each resource"
  default     = ""
}
variable "region" {
  default = "us-east-1"
}
###################vpc########################
##################public_EC2############################################
variable "sonar_ec2_instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "sonar_ec2_volume_size" {
  description = "The root volume size"
  type        = string
}


variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC that the instance security group belongs to"
  type        = string
}


variable "subnet_id" {
  description = "private subnet id for ec2 instances"
  type        = string
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
#variable "sg_alb_ingress_rules" {
#  description = "A list of ingress_rules to attach alb"
#  type        = list(string)
}
variable "sg_sonar_ingress_rules" {
  description = "A list of ingress_rules to attach alb"
  type        = list(string)
}
variable "iam_instance_profile" {
  description = "A pre-defined profile to attach to the instance (default is to build our own)"
  type        = string
}

#variable "alb_arn" {
#  description = "A pre-defined alb to attach to the instance"
#  type        = string
#}

variable "alb_listener_arn" {
  description = "A pre-defined alb_listener to attach to the alb"
  type        = string
}


variable "source_security_group_id" {
   description = "a source_security_group_id to attach"
   type        = string
}
