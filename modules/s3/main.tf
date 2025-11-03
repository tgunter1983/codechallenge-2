# --- S3 Bucket ---
resource "aws_s3_bucket" "hello_bucket" {
  bucket_prefix = "hello-world-bucket-"

  tags = {
    Name        = "hello-world-bucket"
    Environment = "demo"
  }
}

# --- S3 Bucket Versioning ---
resource "aws_s3_bucket_versioning" "hello_bucket_versioning" {
  bucket = aws_s3_bucket.hello_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# --- S3 Bucket Encryption ---
resource "aws_s3_bucket_server_side_encryption_configuration" "hello_bucket_encryption" {
  bucket = aws_s3_bucket.hello_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# --- Block Public Access ---
resource "aws_s3_bucket_public_access_block" "hello_bucket_block" {
  bucket                  = aws_s3_bucket.hello_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
