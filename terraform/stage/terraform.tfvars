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
region                            = "eu-west-2"
vpc_cidr                          = "10.0.0/16"
aws_azs                           = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
nat_gateway_count                 = 1
number_additional_private_subnets = 3

#Secondary VPC Configuration

region_secondary_network = "eu-west-1"
vpc_secondary_name       = "stage-vpc-secondary"
vpc_secondary_cidr       = "10.1.0/16"
aws_azs_secondary        = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]


