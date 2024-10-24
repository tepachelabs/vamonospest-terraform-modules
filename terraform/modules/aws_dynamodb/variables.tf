variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "VamonosPestControl"
}

variable "environment" {
  default = "prod"
}

variable "dynamodb_tag_name" {
  description = "The name of the DynamoDB table tag"
  type        = string
  default     = "Vamonospest Terraform"
}

variable "user_name" {
  description = "The name of the DynamoDB user"
  type        = string
}
