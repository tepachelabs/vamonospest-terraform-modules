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
        Sid = "VisualEditor0"
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "s3:ListAllMyBuckets"
        ]
        Resource = "*"
      }
    ]
  })
}