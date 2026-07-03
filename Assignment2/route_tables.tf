#########################################
# Public Route Table
#########################################

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.assignment_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

  tags = {
    Name = "Assignment2-Public-RT"
  }

}

#########################################
# Public Route Table Association
#########################################

resource "aws_route_table_association" "public_assoc" {

  subnet_id = aws_subnet.public_subnet.id

  route_table_id = aws_route_table.public_rt.id

}

#########################################
# Private Route Table
#########################################

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.assignment_vpc.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id

  }

  tags = {
    Name = "Assignment2-Private-RT"
  }

}

#########################################
# Private Route Table Association
#########################################

resource "aws_route_table_association" "private_assoc" {

  subnet_id = aws_subnet.private_subnet.id

  route_table_id = aws_route_table.private_rt.id

}