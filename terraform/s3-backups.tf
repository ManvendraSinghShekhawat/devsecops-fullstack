resource "aws_s3_bucket" "backups" {
  bucket = "${var.project_name}-backups-${random_id.bucket_id.hex}"
  force_destroy = true
  versioning {
    enabled = true
  }
  lifecycle_rule {
    enabled = true
    expiration {
      days = 30
    }
  }
  tags = {
    Name = "${var.project_name}-backups"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

