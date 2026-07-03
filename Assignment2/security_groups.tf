#########################################
# Frontend Security Group
#########################################

resource "aws_security_group" "frontend_sg" {

  name        = "Assignment2-Frontend-SG"
  description = "Security group for Apache frontend"
  vpc_id      = aws_vpc.assignment_vpc.id

  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Assignment2-Frontend-SG"
  }

}

#########################################
# Backend Security Group
#########################################

resource "aws_security_group" "backend_sg" {

  name        = "Assignment2-Backend-SG"
  description = "Security group for MongoDB backend"
  vpc_id      = aws_vpc.assignment_vpc.id

  ingress {

    description = "MongoDB from Frontend"

    from_port = 27017
    to_port   = 27017

    protocol = "tcp"

    security_groups = [
      aws_security_group.frontend_sg.id
    ]

  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]

  }

  tags = {
    Name = "Assignment2-Backend-SG"
  }

}