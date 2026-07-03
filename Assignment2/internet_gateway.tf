#########################################
# Internet Gateway
#########################################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.assignment_vpc.id

  tags = {
    Name = "Assignment2-IGW"
  }

}