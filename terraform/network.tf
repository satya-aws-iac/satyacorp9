# VPC Module
module "vpc" {
  source = "./modules-registry/vpc/"

  # These are the input variables being passed to your VPC module
  aws_region               = var.aws_region
  vpc_name                 = var.vpc_name
  vpc_cidr                 = var.vpc_cidr
  aws_azs                  = var.aws_azs
  nat_gateway_count        = var.nat_gateway_count
  namespace                = var.namespace # <--- IMPORTANT: This looks like a string literal, not a variable reference
  internet_gateway_enabled = true
  nat_enabled              = true
  global_tags              = var.global_tags
}
