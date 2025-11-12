output "primary_bucket_url" {
  value = aws_s3_bucket.primary.website_endpoint
  description = "URL of the primary S3 bucket website"
}

output "backup_bucket_url" {
  value = aws_s3_bucket.backup.website_endpoint
  description = "URL of the backup S3 bucket website"
}
