#########################################
# Amazon Linux 2023 AMI
#########################################

data "aws_ami" "amazon_linux" {

  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "al2023-ami-2023*-x86_64"
    ]
  }
}

#########################################
# Frontend EC2
#########################################

resource "aws_instance" "frontend" {

  ami = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  subnet_id = aws_subnet.public_subnet.id

  vpc_security_group_ids = [
    aws_security_group.frontend_sg.id
  ]

  key_name = var.key_name

  associate_public_ip_address = true

  user_data = file("${path.module}/userdata/apache.sh")

  tags = {
    Name = "Assignment2-Frontend"
  }

}

#########################################
# Backend EC2
#########################################

resource "aws_instance" "backend" {

  ami = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  subnet_id = aws_subnet.private_subnet.id

  vpc_security_group_ids = [
    aws_security_group.backend_sg.id
  ]

  key_name = var.key_name

  associate_public_ip_address = false

  user_data = file("${path.module}/userdata/mongodb.sh")

  tags = {
    Name = "Assignment2-Backend"
  }

}