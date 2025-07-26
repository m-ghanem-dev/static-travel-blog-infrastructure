provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "travel_blog" {
  bucket = "static-travel-blog-bucket-jskldjlq341"
  acl    = "private"
}
