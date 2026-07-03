#########################################
# Public Subnet
#########################################

resource "aws_subnet" "public_subnet" {

  vpc_id = aws_vpc.assignment_vpc.id

  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-south-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "Assignment2-Public-Subnet"
  }

}

#########################################
# Private Subnet
#########################################

resource "aws_subnet" "private_subnet" {

  vpc_id = aws_vpc.assignment_vpc.id

  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-south-1a"

  map_public_ip_on_launch = false

  tags = {
    Name = "Assignment2-Private-Subnet"
  }

}