#S3プライベートバケットの定義
resource "aws_s3_bucket" "private-walter" {
  bucket = "gachimuchi-terraform20210102"

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
