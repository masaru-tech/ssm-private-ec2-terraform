resource "aws_s3_bucket" "ssm-log-bucket" {
  bucket = "ec2-ssm-bucket"
  acl    = "private"
}