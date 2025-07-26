variable "namespace" {
  description = "Namespace for the resources"
  type        = string

}


variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}


variable "vpc_name" {
  description = "Name of the VPC"
  type        = string

}



variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}



variable "aws_azs" {
  description = "List of availability zones for the primary VPC"
  type        = list(any)
}




variable "global_tags" {
  type = map(string)
}

variable "internet_gateway_enabled" {
  description = "Enable Internet Gateway"
  type        = number
  default     = 1

}