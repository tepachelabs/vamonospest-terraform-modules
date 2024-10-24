output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_arn
}

output "dynamodb_table_id" {
  description = "The ID of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_id
}

output "dynamodb_iam_role_arn" {
  description = "The ARN of the IAM role for DynamoDB"
  value       = module.dynamodb_table.dynamodb_iam_role_arn
}

output "aws_user_name" {
  description = "The name of the IAM user for vamonospest in general"
  value       = aws_iam_user.this.name
}

output "aws_iam_user_arn" {
  description = "The ARN of the IAM user for vamonospest in general"
  value       = aws_iam_user.this.arn
}

output "aws_access_key_id" {
  description = "AWS Access Key ID for the new user"
  value       = aws_iam_access_key.this.id
}

output "aws_secret_access_key" {
  description = "AWS Secret Access Key for the new user"
  value       = aws_iam_access_key.this.secret
  sensitive   = true
}
