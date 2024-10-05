variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "visits-table"
}

variable "dynamodb_tag_name" {
  description = "The name of the DynamoDB table tag"
  type        = string
  default     = "Vamonospest Terraform"
}

variable "dynamodb_user_name" {
  description = "The name of the DynamoDB user"
  type        = string
  default     = "retool-user"
}