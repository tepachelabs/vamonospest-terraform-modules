terraform {
  backend "s3" {
    bucket         = "tepache-terraform-state-bucket"
    key            = "vamonos-pest/statefile.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}