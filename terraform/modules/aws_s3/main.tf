resource "aws_s3_bucket" "this" {
  bucket = "vamonospest-photos-bucket"
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_iam_policy" "s3_upload_download_policy" {
  name        = "retool-s3-upload-download-policy"
  description = "Allow uploads, downloads, and deletes from the S3 bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Resource": "arn:aws:s3:::${aws_s3_bucket.this.bucket}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*"
    }
  ]
}
EOF
}

resource "aws_s3_bucket_cors_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  cors_rule {
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["*"]  # Adjust to specific Retool URL if needed
    allowed_headers = ["*"]
  }
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = var.user_name
  policy_arn = aws_iam_policy.s3_upload_download_policy.arn
}
