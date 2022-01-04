variable "prefix" {
  description = "Prefix name for each resource"
  default     = ""
}
variable "region" {
  default = "us-east-1"
}
###################vpc########################
variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  type        = bool
  default     = false
}
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "Should be true if you want to provision a single shared NAT Gateway for each az"
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}


##################public_EC2############################################
variable "jenkins_ec2_instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "jenkins_ec2_volume_size" {
  description = "The root volume size"
  type        = string
}
###############jenkins security_sg#########################
variable "ingress_with_cidr_blocks_from_port" {
   description = "enable port"
   type        = number
}
variable "ingress_with_cidr_blocks_to_port" {
   description = "enable port"
   type        = number
}
variable "egress_with_cidr_blocks_from_port" {
    description = "enable port"
    type        = number 
}
variable "egress_with_cidr_blocks_to_port" {
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
variable "sg_alb_ingress_rules" {
  description = "A list of ingress_rules to attach alb"
  type        = list(string)
}
variable "sg_jenkins_ingress_rules" {
  description = "A list of ingress_rules to attach alb"
  type        = list(string)
}
variable "iam_instance_profile" {
  description = "A pre-defined profile to attach to the instance (default is to build our own)"
  type        = string
}

variable "access_logs" {
  description = "Map containing access logging configuration for load balancer."
  type        = map(string)
  default     = {}
}
variable "bucket_name" {
     description = "creation of a bucket name for the vpc_logs"
    type = string
}
variable "bucket_name_1" {
     description = "creation of the bucket for the elb_logs"
      type = string
}
variable "sg_engress_cidr_block" {
     description = "The CIDR block for the engress. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
     type = string
}

