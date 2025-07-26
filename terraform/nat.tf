resource "aws-eip" "nat-eip" {
  domain = "vpc"
  tags = {
    Name = "stage-nat-eip"
  }

}


resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "stage-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}