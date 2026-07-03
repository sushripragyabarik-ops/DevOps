terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

#########################################
# Find the latest Amazon Linux 2023 AMI
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
# Default VPC
#########################################

data "aws_vpc" "default" {

  default = true

}

#########################################
# Default Subnet
#########################################

data "aws_subnets" "default" {

  filter {
    name = "vpc-id"

    values = [data.aws_vpc.default.id]
  }
}

#########################################
# Security Group
#########################################

resource "aws_security_group" "ec2_sg" {

  name = "assignment1-ec2-sg"

  description = "Allow SSH and HTTP"

  vpc_id = data.aws_vpc.default.id

  ingress {

    description = "SSH"

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    description = "HTTP"

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}

#########################################
# EC2 Instance
#########################################

resource "aws_instance" "assignment_ec2" {

  ami = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  subnet_id = data.aws_subnets.default.ids[0]

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  key_name = var.key_name

  associate_public_ip_address = false

  tags = {

    Name = "Assignment1-EC2"

  }

}

#########################################
# S3 Bucket
#########################################

resource "aws_s3_bucket" "assignment_bucket" {

  bucket = var.bucket_name

  force_destroy = true

  tags = {
    Name = "Assignment1-S3"
  }

}

#########################################
# SQS Queue
#########################################

resource "aws_sqs_queue" "assignment_queue" {

  name = "assignment1-queue"

  visibility_timeout_seconds = 30

  message_retention_seconds = 345600

  delay_seconds = 0

  receive_wait_time_seconds = 0

  tags = {
    Name = "Assignment1-SQS"
  }

}

#########################################
# IAM Role for Lambda
#########################################

resource "aws_iam_role" "lambda_role" {

  name = "assignment1_lambda_role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Action = "sts:AssumeRole"

        Effect = "Allow"

        Principal = {

          Service = "lambda.amazonaws.com"

        }

      }

    ]

  })

}

#########################################
# Attach CloudWatch Logs Policy
#########################################

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {

  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

#########################################
# Lambda Function
#########################################
resource "aws_lambda_function" "assignment_lambda" {

  function_name = "assignment1-lambda"

  role = aws_iam_role.lambda_role.arn

  handler = "lambda.lambda_handler"

  runtime = "python3.12"

  architectures = ["x86_64"]

  filename = var.lambda_zip

  source_code_hash = filebase64sha256(var.lambda_zip)

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic_execution
  ]

}

#########################################
# Allow S3 to Invoke Lambda
#########################################

resource "aws_lambda_permission" "allow_s3" {

  statement_id = "AllowExecutionFromS3"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.assignment_lambda.function_name

  principal = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.assignment_bucket.arn

}

#########################################
# S3 Trigger
#########################################

resource "aws_s3_bucket_notification" "bucket_notification" {

  bucket = aws_s3_bucket.assignment_bucket.id

  lambda_function {

    lambda_function_arn = aws_lambda_function.assignment_lambda.arn

    events = [
      "s3:ObjectCreated:*"
    ]

  }

  depends_on = [
    aws_lambda_permission.allow_s3
  ]

}