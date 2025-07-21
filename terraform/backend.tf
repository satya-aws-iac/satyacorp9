#create  s3 bucket
resource "aws_s3_bucket" "tfstatebucket-satya" {
  bucket = "s3-mylavarsatyacorp-state-bucket"
}




# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "tfstate-lock-table-satya" {
  name         = "tfstate-lock-table-satya"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "tfstate-lock-table-satya"
    Environment = "Production"
  }
}