output "s3_bucket_name" {
  value = aws_s3_bucket.s3_logs_bucket.id
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.s3_logs_bucket.arn
}
