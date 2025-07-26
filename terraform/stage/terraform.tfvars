# Network Configuration for Terraform
# This file defines the network resources for the stage environment.

namespace = "stage"

global_tags = {
  terraform   = "true"
  Environment = "stage"
  Project     = "satyacorp"
  Owner       = "Satya"
  ManagedBy   = "Terraform"
  CreatedBy   = "Satya"
  email       = "satyanarayanamylavarapuaws@gmail.com"
}

vpc_name                          = "stage-vpc"
vpc_cidr                          = "10.0.0/16"
aws_azs                           = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
nat_gateway_count                 = 1
number_additional_private_subnets = 3

