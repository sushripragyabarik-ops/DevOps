output "instance_id" {
  value = aws_instance.assignment_ec2.id
}

output "public_ip" {
  value = aws_instance.assignment_ec2.public_ip
}

output "public_dns" {
  value = aws_instance.assignment_ec2.public_dns
}

output "bucket_name" {
  value = aws_s3_bucket.assignment_bucket.bucket
}

output "queue_url" {
  value = aws_sqs_queue.assignment_queue.id
}

output "lambda_name" {
  value = aws_lambda_function.assignment_lambda.function_name
}