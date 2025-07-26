resource "aws_route_table" "private" {
  vpc_id = aws_vpc.stage-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
  tags = {
    name = "stage-private-route-table"
  }

}

resource "aws_route_table_association" "private-subnet-assoc" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-zone2-assoc" {
  subnet_id      = aws_subnet.private_zone2.id
  route_table_id = aws_route_table.private.id
}