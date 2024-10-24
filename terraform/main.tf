provider "aws" {
  region = var.region
}

# This assumes you have a module that sets up your DynamoDB tables
module "dynamodb_table" {
  source = "./modules/aws_dynamodb"

  dynamodb_table_name = "VamonosPestControl"
  dynamodb_tag_name   = "VamonosPest Terraform"
  dynamodb_user_name  = "dynamodb-user"
}

output "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_arn  # Reference module output
}

output "dynamodb_table_id" {
  description = "The ID of the DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_id
}

output "dynamodb_aws_access_key_id" {
  description = "AWS Access Key ID for the DynamoDB user"
  value       = module.dynamodb_table.dynamodb_aws_access_key_id
}

output "dynamodb_aws_secret_access_key" {
  description = "AWS Secret Access Key for the DynamoDB user"
  value       = module.dynamodb_table.dynamodb_aws_secret_access_key
  sensitive   = true
}

output "dynamodb_iam_role_arn" {
  description = "The ARN of the IAM role for DynamoDB"
  value       = module.dynamodb_table.dynamodb_iam_role_arn
}