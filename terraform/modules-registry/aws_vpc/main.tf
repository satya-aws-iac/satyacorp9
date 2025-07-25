# This file defines the core resources for the AWS VPC module.

# Create the Virtual Private Cloud (VPC)
resource "aws_vpc" "main" {
  # The CIDR block for the VPC. This is a required input.
  cidr_block = var.vpc_cidr_block

  # Enable DNS hostnames within the VPC.
  enable_dns_hostnames = true

  # Enable DNS support within the VPC.
  enable_dns_support = true

  # Apply common tags to the VPC.
  tags = merge(
    {
      Name = var.vpc_name
    },
    var.tags
  )
}

# Create an Internet Gateway (IGW) for public subnet connectivity.
resource "aws_internet_gateway" "main" {
  # Associate the IGW with the created VPC.
  vpc_id = aws_vpc.main.id

  # Apply common tags to the Internet Gateway.
  tags = merge(
    {
      Name = "${var.vpc_name}-igw"
    },
    var.tags
  )
}

# Create public subnets.
# The count meta-argument allows us to create multiple subnets based on the number of public_subnet_cidrs.
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  # Associate the subnet with the VPC.
  vpc_id = aws_vpc.main.id

  # Assign a CIDR block from the input list for each public subnet.
  cidr_block = var.public_subnet_cidrs[count.index]

  # Assign an Availability Zone (AZ) from the input list for each public subnet.
  availability_zone = var.availability_zones[count.index]

  # Automatically assign public IP addresses to instances launched in this subnet.
  map_public_ip_on_launch = true

  # Apply common tags to each public subnet.
  tags = merge(
    {
      Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
    },
    var.tags
  )
}

# Create private subnets.
# The count meta-argument allows us to create multiple subnets based on the number of private_subnet_cidrs.
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  # Associate the subnet with the VPC.
  vpc_id = aws_vpc.main.id

  # Assign a CIDR block from the input list for each private subnet.
  cidr_block = var.private_subnet_cidrs[count.index]

  # Assign an Availability Zone (AZ) from the input list for each private subnet.
  availability_zone = var.availability_zones[count.index]

  # Apply common tags to each private subnet.
  tags = merge(
    {
      Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
    },
    var.tags
  )
}

# Create an Elastic IP (EIP) for each NAT Gateway.
# The count is based on the number of public subnets, as each NAT Gateway needs to be in a public subnet.
resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? length(var.public_subnet_cidrs) : 0

  # Ensure the EIP is associated with the VPC.
  vpc = true

  # Apply common tags to each EIP.
  tags = merge(
    {
      Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
    },
    var.tags
  )
}

# Create NAT Gateways.
# The count is based on the number of public subnets if NAT Gateway is enabled.
resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? length(var.public_subnet_cidrs) : 0

  # Associate the NAT Gateway with a public subnet.
  subnet_id = aws_subnet.public[count.index].id

  # Associate the EIP with the NAT Gateway.
  allocation_id = aws_eip.nat[count.index].id

  # Apply common tags to each NAT Gateway.
  tags = merge(
    {
      Name = "${var.vpc_name}-nat-gateway-${count.index + 1}"
    },
    var.tags
  )

  # Explicitly depend on the Internet Gateway to ensure it's created first.
  depends_on = [aws_internet_gateway.main]
}

# Create a route table for public subnets.
resource "aws_route_table" "public" {
  # Associate the route table with the VPC.
  vpc_id = aws_vpc.main.id

  # Add a route to the Internet Gateway for all outbound traffic (0.0.0.0/0).
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  # Apply common tags to the public route table.
  tags = merge(
    {
      Name = "${var.vpc_name}-public-rt"
    },
    var.tags
  )
}

# Associate public subnets with the public route table.
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  # Associate each public subnet with the public route table.
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create route tables for private subnets.
# Each private subnet will have its own route table pointing to its respective NAT Gateway.
resource "aws_route_table" "private" {
  count = var.enable_nat_gateway ? length(var.private_subnet_cidrs) : 0

  # Associate the route table with the VPC.
  vpc_id = aws_vpc.main.id

  # Add a route to the NAT Gateway for all outbound traffic (0.0.0.0/0).
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  # Apply common tags to each private route table.
  tags = merge(
    {
      Name = "${var.vpc_name}-private-rt-${count.index + 1}"
    },
    var.tags
  )
}

# Associate private subnets with their respective private route tables.
resource "aws_route_table_association" "private" {
  count = var.enable_nat_gateway ? length(var.private_subnet_cidrs) : 0

  # Associate each private subnet with its corresponding private route table.
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
# modules/vpc/variables.tf
# This file defines the input variables for the AWS VPC module.

variable "vpc_name" {
  description = "The name of the VPC."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of Availability Zones to deploy subnets into. Must match the number of public/private subnets."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateways for private subnet outbound internet access."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to all resources created by this module."
  type        = map(string)
  default     = {}
}

# modules/vpc/outputs.tf
# This file defines the outputs of the AWS VPC module.

output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the created VPC."
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "A list of IDs of the public subnets."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "A list of IDs of the private subnets."
  value       = aws_subnet.private[*].id
}

output "public_route_table_id" {
  description = "The ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "A list of IDs of the private route tables."
  value       = aws_route_table.private[*].id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
  description = "A list of IDs of the NAT Gateways (if enabled)."
  value       = aws_nat_gateway.main[*].id
}
