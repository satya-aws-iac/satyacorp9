
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.stage-vpc.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "eu-west-2a"

  tags = {
    "Name"                                      = "stage-public-subnet-us-west-2a"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}


resource "aws_subnet" "public_zone2" {
  vpc_id            = aws_vpc.stage-vpc.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "eu-west-2b"


  tags = {
    "Name"                                      = "stage-public-subnet-us-west-2b"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }

}
