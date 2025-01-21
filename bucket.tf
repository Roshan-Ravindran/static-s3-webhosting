resource "aws_s3_bucket" "itsroshanr" {
  bucket = "itsroshanr"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.itsroshanr.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.itsroshanr.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {

    sid    = "PublicReadGetObject"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.itsroshanr.arn,
      "${aws_s3_bucket.itsroshanr.arn}/*",
    ]
  }
}

resource "aws_s3_object" "object" {
  bucket = "itsroshanr"
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
  etag = filemd5("index.html")
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.itsroshanr.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}