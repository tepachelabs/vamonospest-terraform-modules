output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_arn
}

output "dynamodb_table_id" {
  description = "The ID of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_id
}

output "dynamodb_table_stream_arn" {
  value       = module.dynamodb_table.dynamodb_table_stream_arn
}

# Output the Access Key ID and Secret Access Key (for Retool)
output "dynamodb_aws_access_key_id" {
  description = "AWS Access Key ID for the DynamoDB user"
  value       = aws_iam_access_key.dynamodb_access_key.id
}

output "dynamodb_aws_secret_access_key" {
  description = "AWS Secret Access Key for the DynamoDB user"
  value       = aws_iam_access_key.dynamodb_access_key.secret
  sensitive   = true
}

# Output the IAM Role ARN for Retool to assume
output "dynamodb_iam_role_arn" {
  description = "The ARN of the IAM role for DynamoDB"
  value       = aws_iam_role.dynamodb_role.arn
}
