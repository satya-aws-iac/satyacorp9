variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "namespace" {
  description = "Namespace for resource naming"
  type        = string
}

variable "global_tags" {
  description = "Map of tags to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "internet_gateway_enabled" {
  description = "Enable/disable Internet Gateway creation"
  type        = bool
  default     = true
}

variable "create_public_subnets" {
  description = "Enable/disable public subnet creation"
  type        = bool
  default     = true
}

variable "aws_azs" {
  description = "List of Availability Zones for subnet creation"
  type        = list(string)
}

variable "subnet_prefix_extension" {
  description = "Number of additional bits with which to extend the vpc CIDR block"
  type        = number
  default     = 8
}

variable "nat_enabled" {
  description = "Enable/disable NAT Gateway creation"
  type        = bool
  default     = true
}

variable "nat_gateway_count" {
  description = "Number of NAT Gateways to create"
  type        = number
  default     = 1
}