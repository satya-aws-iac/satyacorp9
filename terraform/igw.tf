
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.stage-vpc.id

  tags = {
    Name = "stage-igw"
  }

}