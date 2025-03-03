resource "aws_s3_bucket" "terraform_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_policy" "terraform_access_bucket_policy" {
  bucket = aws_s3_bucket.terraform_bucket.id
  policy = file("s3_permissions.json")
}

resource "aws_s3_bucket_versioning" "enable_versioning_terraform_bucket" {
  bucket = aws_s3_bucket.terraform_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
