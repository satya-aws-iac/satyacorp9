variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones to use for subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets (must match length of availability_zones)"
  type        = list(string)
}

variable "private_subnet_cidrs" { # Often a required input as well
  description = "List of CIDR blocks for private subnets (must match length of availability_zones)"
  type        = list(string)
  default     = [] # Or provide a default if it's optional
}

variable "enable_nat_gateway" { # Or similar name for nat_enabled
  description = "Whether to create NAT Gateways"
  type        = bool
  default     = true
}

variable "single_nat_gateway" { # If you can control count, it might be a boolean
  description = "Whether to use a single NAT Gateway across all AZs"
  type        = bool
  default     = false
}

variable "tags" { # Often modules use a generic 'tags' variable
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# The module might automatically get region from provider config, or have a specific input for it
# variable "region" { # if the module explicitly asks for region
#   description = "AWS region"
#   type        = string
# }