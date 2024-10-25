resource "aws_iam_user" "this" {
  name = var.user_name
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

# This is only because right now we are using retool, but we will remove this once migrated (if we do)
resource "aws_iam_user_policy" "retool_policy" {
  name = "${aws_iam_user.this.name}-retool-policy"
  user = aws_iam_user.this.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VisualEditor0"
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation",
          "s3:ListBucket", # Allows listing objects in the bucket
          "s3:PutObject",  # Allows uploading files
          "s3:GetObject"   # Allows retrieving files
        ]
        Resource = [
          "*",
          "arn:aws:s3:::vamonospest-photos-bucket",  # Permission on the bucket itself
          "arn:aws:s3:::vamonospest-photos-bucket/*" # Permission on all objects in the bucket
        ]
      }
    ]
  })
}
