terraform {
  backend "s3" {
    bucket         = "s3-mylavarsatyacorp-state-bucket"
    key            = "global/mystatefile/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "tfstate-lock-table-satya"
    encrypt        = true

  }
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}