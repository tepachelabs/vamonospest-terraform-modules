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

# Create a policy to allow uploads and downloads by the Retool user
resource "aws_iam_policy" "s3_upload_download_policy" {
  name        = "retool-s3-upload-download-policy"
  description = "Allow uploads and downloads from the S3 bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.this.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = var.user_name
  policy_arn = aws_iam_policy.s3_upload_download_policy.arn
}
