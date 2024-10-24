provider "aws" {
  region = var.region
}

resource "aws_iam_user" "this" {
  name = "vamonospest-user"
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

module "s3_bucket" {
  source = "./modules/aws_s3"

  user_name   = aws_iam_user.this.name
  environment = "prod"
}


module "dynamodb_table" {
  source = "./modules/aws_dynamodb"

  dynamodb_table_name = "VamonosPestControl"
  dynamodb_tag_name   = "VamonosPest Terraform"
  user_name           = aws_iam_user.this.name
  environment         = "prod"

  providers = {
    aws = aws
  }
}
