provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "travel_blog" {
  bucket = "static-travel-blog-bucket-jskldjlq341"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.travel_blog.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.travel_blog.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.travel_blog.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.travel_blog.arn}/*"
      }
    ]
  })
}
