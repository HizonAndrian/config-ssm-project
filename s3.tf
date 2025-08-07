resource "aws_s3_bucket" "s3_config" {
  bucket = var.s3_bucket_name

}

resource "aws_s3_bucket_ownership_controls" "s3_ownership_control" {
  bucket = aws_s3_bucket.s3_config.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {

  depends_on = [aws_s3_bucket_ownership_controls.s3_ownership_control]
  bucket     = aws_s3_bucket.s3_config.id
  acl        = "private"
}

resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket = aws_s3_bucket.s3_config.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.s3_config.id

  rule {

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_policy" "name" {
  bucket = aws_s3_bucket.s3_config.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Ec2 with AWS Config"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = ["s3:PutObject"]
        Resource = "arn:aws:s3:::${aws_s3_bucket.s3_config.id}/*"
      },
      {
        Sid    = "Get ACL"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = ["s3:GetBucketAcl"]
        Resource = "arn:aws:s3:::${aws_s3_bucket.s3_config.id}"
      }

    ]
  })
}