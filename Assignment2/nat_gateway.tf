#########################################
# Elastic IP for NAT Gateway
#########################################

resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "Assignment2-NAT-EIP"
  }

}

#########################################
# NAT Gateway
#########################################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public_subnet.id

  tags = {
    Name = "Assignment2-NAT"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]

}