# Define the AWS VPC itself
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = merge(
    var.global_tags,
    {
      Name      = var.vpc_name
      Namespace = var.namespace
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  count  = var.internet_gateway_enabled ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.global_tags,
    {
      Name = "${var.vpc_name}-igw"
    }
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count             = var.create_public_subnets ? length(var.aws_azs) : 0
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_prefix_extension, count.index)
  availability_zone = element(var.aws_azs, count.index)

  map_public_ip_on_launch = true

  tags = merge(
    var.global_tags,
    {
      Name = format("${var.vpc_name}-public-%s", element(var.aws_azs, count.index))
      Tier = "public"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.aws_azs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_prefix_extension, count.index + length(var.aws_azs))
  availability_zone = element(var.aws_azs, count.index)

  tags = merge(
    var.global_tags,
    {
      Name = format("${var.vpc_name}-private-%s", element(var.aws_azs, count.index))
      Tier = "private"
    }
  )
}

# NAT Gateway Resources
resource "aws_eip" "nat" {
  count  = var.nat_enabled ? var.nat_gateway_count : 0
  domain = "vpc"

  tags = merge(
    var.global_tags,
    {
      Name = "${var.vpc_name}-nat-eip-${count.index + 1}"
    }
  )
}

resource "aws_nat_gateway" "this" {
  count         = var.nat_enabled ? var.nat_gateway_count : 0
  allocation_id = element(aws_eip.nat[*].id, count.index)
  subnet_id     = element(aws_subnet.public[*].id, count.index)

  depends_on = [aws_internet_gateway.this]

  tags = merge(
    var.global_tags,
    {
      Name = "${var.vpc_name}-nat-gw-${count.index + 1}"
    }
  )
}

# Route Tables
resource "aws_route_table" "public" {
  count  = var.create_public_subnets ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = merge(
    var.global_tags,
    {
      Name = "${var.vpc_name}-public-rt"
    }
  )
}

resource "aws_route_table" "private" {
  count  = length(var.aws_azs)
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.nat_enabled ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = element(aws_nat_gateway.this[*].id, count.index)
    }
  }

  tags = merge(
    var.global_tags,
    {
      Name = "${var.vpc_name}-private-rt-${count.index + 1}"
    }
  )
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  count          = var.create_public_subnets ? length(var.aws_azs) : 0
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "private" {
  count          = length(var.aws_azs)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}