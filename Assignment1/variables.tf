variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "bucket_name" {
  description = "Unique S3 Bucket Name"
  type        = string
}

variable "lambda_zip" {
  description = "Path to Lambda ZIP"
  type        = string
}