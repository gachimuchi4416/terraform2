#S3プライベートバケットの定義
resource "aws_s3_bucket" "private-walter" {
  bucket        = "gachimuchi-terraform20210102"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#ブロックパブリックアクセス (バケット設定)
resource "aws_s3_bucket_public_access_block" "private-walter" {
  bucket                  = aws_s3_bucket.private-walter.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#S3パブリックバケットの定義
resource "aws_s3_bucket" "public-walter" {
  bucket        = "public-gachimuchi-terraform20210102"
  acl           = "public-read"
  force_destroy = true

  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}

#ALBのログバケット
resource "aws_s3_bucket" "alb_log" {
  bucket        = "alb-log-gachimuchi-terraform20210102"
  force_destroy = true

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}
#ALBログバケットポリシーの定義
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["582318560864"]
    }
  }
}