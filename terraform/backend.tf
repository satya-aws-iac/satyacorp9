# versions.tf (or main.tf)
terraform {
  backend "s3" {
    bucket         = "s3-mylavarsatyacorp-state-bucket"
    key            = "global/mystatefile/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "tfstate-lock-table-satya"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "eu-west-2" # Ensure this matches your S3 backend region
}

# s3.tf
resource "aws_s3_bucket" "tfstatebucket-satya" {
  bucket = "s3-mylavarsatyacorp-state-bucket"

  # It's good practice to add tags for organization
  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Production"
  }
}

# dynamodb.tf
resource "aws_dynamodb_table" "tfstate-lock-table-satya" {
  name                        = "tfstate-lock-table-satya"
  billing_mode                = "PAY_PER_REQUEST"
  hash_key                    = "LockID"
  deletion_protection_enabled = true

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "tfstate-lock-table-satya"
    Environment = "Production"
  }
}