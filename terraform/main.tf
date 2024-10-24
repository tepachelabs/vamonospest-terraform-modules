provider "aws" {
  region = var.region
}

module "iam_user" {
  source = "./modules/aws_iam"

  user_name = "vamonospest"
  environment = var.environment

  providers = {
    aws = aws
  }
}

module "s3_bucket" {
  source = "./modules/aws_s3"

  user_name   = module.iam_user.aws_user_name
  environment = var.environment

  providers = {
    aws = aws
  }
}


module "dynamodb_table" {
  source = "./modules/aws_dynamodb"

  dynamodb_table_name = "VamonosPestControl"
  dynamodb_tag_name   = "VamonosPest Terraform"
  user_name           = module.iam_user.aws_user_name
  environment         = var.environment

  providers = {
    aws = aws
  }
}
