resource "aws_subnet" "db-subnet" {
  vpc_id            = aws_vpc.stage-vpc.id
  cidr_block        = "10.0.128.0/19"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "stage-db-subnet-eu-west-2a"

  }

}

resource "aws_subnet" "db_zone2" {
  vpc_id            = aws_vpc.stage-vpc.id
  cidr_block        = "10.0.160.0/19"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "stage-db-subnet-eu-west-2b"

  }
}