# Remove these blocks if they already exist in your AWS account
# resource "aws_s3_bucket" "tfstatebucket-satya" {
#   bucket = "s3-mylavarsatyacorp-state-bucket"
# }

# resource "aws_dynamodb_table" "tfstate-lock-table-satya" {
#   name                        = "tfstate-lock-table-satya"
#   billing_mode                = "PAY_PER_REQUEST"
#   hash_key                    = "LockID"
#   deletion_protection_enabled = true

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name        = "tfstate-lock-table-satya"
#     Environment = "Production"
#   }
# }

terraform {
  backend "s3" {
    bucket         = "s3-mylavarsatyacorp-state-bucket"     # Your existing S3 bucket name
    key            = "terraform/state/your-project.tfstate" # A path within the bucket for your state file
    region         = "your-aws-region"                      # IMPORTANT: Specify your AWS region here
    dynamodb_table = "tfstate-lock-table-satya"             # Your existing DynamoDB lock table name
    encrypt        = true                                   # Recommended for state file encryption
  }
}