provider "aws" {
  region = "us-west-2"
}

# Data source to fetch the current AWS account ID
data "aws_caller_identity" "current" {}

module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 2.0"

  name         = var.dynamodb_table_name
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attributes = [
    {
      name = "PK"
      type = "S"
    },
    {
      name = "SK"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "GSI_ProviderID"
      hash_key        = "provider_id"
      range_key       = "service_date"
      projection_type = "ALL"
    }
  ]

  tags = {
    Name        = var.dynamodb_table_name
    Environment = "prd"
  }
}

resource "aws_iam_role" "dynamodb_role" {
  name = "${var.dynamodb_user_name}-dynamodb-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.dynamodb_user.name}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach a policy to the role allowing access to the DynamoDB table and listing tables
resource "aws_iam_role_policy" "dynamodb_access_policy" {
  name = "${var.dynamodb_user_name}-dynamodb-access-policy"
  role = aws_iam_role.dynamodb_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query",
        ],
        Resource = "arn:aws:dynamodb:us-west-2:${data.aws_caller_identity.current.account_id}:table/${module.dynamodb_table.dynamodb_table_arn}"
      },
      {
        Effect   = "Allow",
        Action   = "dynamodb:ListTables",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy" "dynamodb_user_assume_role_policy" {
  name = "${var.dynamodb_user_name}-dynamodb-assume-role-policy"
  user = aws_iam_user.dynamodb_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = aws_iam_role.dynamodb_role.arn
      }
    ]
  })
}

# Create an IAM user for programmatic access (Retool access)
resource "aws_iam_user" "dynamodb_user" {
  name = var.dynamodb_user_name
}

# Attach an inline policy to the user for access to the DynamoDB table
resource "aws_iam_user_policy" "dynamodb_user_policy" {
  name = "${var.dynamodb_user_name}-dynamodb-user-policy"
  user = aws_iam_user.dynamodb_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:ListTables"
        ],
        Resource = module.dynamodb_table.dynamodb_table_arn
      }
    ]
  })
}


# Generate access key and secret key for the IAM user
resource "aws_iam_access_key" "dynamodb_access_key" {
  user = aws_iam_user.dynamodb_user.name
}
