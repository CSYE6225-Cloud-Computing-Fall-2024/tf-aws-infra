resource "aws_s3_bucket" "example_bucket" {
  bucket = uuid()  # Generates a UUID for the bucket name
  acl    = "private"

  # Allow Terraform to delete the bucket, even if not empty.
  force_destroy = true
}
#default encryption with an AES-256 encryption type
resource "aws_s3_bucket_server_side_encryption_configuration" "example_bucket_encryption" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
#transition objects from STANDARD to STANDARD_IA after 30 days
resource "aws_s3_bucket_lifecycle_configuration" "example_bucket_lifecycle" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    id     = "transition_to_ia"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}
