terraform {
  backend "s3" {
    bucket         = "s3-mylavarsatyacorp-state-bucket"
    key            = "global/mystatefile/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "tfstate-lock-table-satya"
    encrypt        = true

  }
}

provider "aws" {
  region = var.aws_region
}