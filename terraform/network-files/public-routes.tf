resource "aws_route_table" "public" {
  vpc_id = aws_vpc.stage-vpc.id

  route {
    cidr_block = "0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    name = "stage-public-route-table"
  }
}


resource "aws_route_table_association" "public-subnet-assoc" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-zone2-assoc" {
  subnet_id      = aws_subnet.public_zone2.id
  route_table_id = aws_route_table.public.id

}