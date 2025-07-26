terraform {
  backend "s3" {
    bucket         = "s3-mylavarsatyacorp-state-bucket"
    key            = "global/mystatefile/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "tfstate-lock-table-satya"
    encrypt        = true

  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use an appropriate version constraint
    }
  }
}

# Optional: if you have provider configuration
provider "aws" {
  region = var.aws_region # Replace with your desired AWS region
  # ... other AWS provider configurations
}