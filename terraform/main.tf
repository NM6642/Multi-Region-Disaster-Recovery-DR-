# Primary Bucket
resource "aws_s3_bucket" "primary" {
  bucket = "my-dr-demo-primary-eunorth1"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
  }

  replication_configuration {
    role = aws_iam_role.s3_replication_role.arn

    rules {
      id     = "replicate-to-backup"
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.backup.arn
        storage_class = "STANDARD"
      }

      filter {
        prefix = ""
      }
    }
  }
}

# Backup Bucket
resource "aws_s3_bucket" "backup" {
  provider = aws.backup
  bucket   = "my-dr-demo-backup-euwest1"

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
  }
}

# IAM Role for S3 Replication
resource "aws_iam_role" "s3_replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "s3.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for replication
resource "aws_iam_role_policy" "s3_replication_policy" {
  name = "s3-replication-policy"
  role = aws_iam_role.s3_replication_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl",
        "s3:GetObjectVersionForReplication",
        "s3:ListBucket",
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      Resource = [
        aws_s3_bucket.primary.arn,
        "${aws_s3_bucket.primary.arn}/*",
        aws_s3_bucket.backup.arn,
        "${aws_s3_bucket.backup.arn}/*"
      ]
    }]
  })
}
# Primary Bucket Policy for health check/demo
resource "aws_s3_bucket_policy" "primary_policy" {
  bucket = aws_s3_bucket.primary.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.primary.arn}/*"
      }
    ]
  })
}

# Backup Bucket Policy for health check/demo
resource "aws_s3_bucket_policy" "backup_policy" {
  provider = aws.backup   
  bucket = aws_s3_bucket.backup.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.backup.arn}/*"
      }
    ]
  })
}


