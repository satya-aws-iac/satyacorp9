resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.stage-vpc.id
  cidr_block        = "10.0.64.0/19"
  availability_zone = "eu-west-2a"

  tags = {
    Name                                        = "stage-private-subnet-eu-west-2a"
   
  }

}

resource "aws_subnet" "private_zone2" {
  vpc_id            = aws_vpc.stage-vpc.id
  cidr_block        = "10.0.96.0/19"
  availability_zone = "eu-west-2b"
  tags = {
    Name                                        = "stage-private-subnet-eu-west-2b"
   
  }

}