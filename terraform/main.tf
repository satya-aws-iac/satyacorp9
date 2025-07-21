resource "aws_iam_user" "test_user" {
  name = "redapple-user"
  tags = {
    Purpose = "Testing"
  }
}