##################################Providers###################################
terraform {
  # Mandatory terraform version - 1.3.1 is the last version on 04/10/2022
  required_version = "~>1.3.0"

  # providers - 4.33.0 the last version on 04/10/2022
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.33.0"
    }
  }
}

# Define aws region
provider "aws" {
  region = var.aws_region
}

# retrieve information abount your account 
data "aws_caller_identity" "current" {}

##############################BucketS3#####################################
# Create a bucket for storage the terraform remote-state
resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket-roger"
  tags   = var.resource_tags
}

#block public access
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


#Encrypt bucket With SSE-S3
resource "aws_s3_bucket_server_side_encryption_configuration" "eyxample" {
  bucket = aws_s3_bucket.example.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#Active versioning on bucket
resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}

#Lifecycle for version archives 
resource "aws_s3_bucket_lifecycle_configuration" "example" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.example]
  bucket     = aws_s3_bucket.example.bucket
  rule {
    id = "config"
    noncurrent_version_expiration {
      newer_noncurrent_versions = 7
      noncurrent_days           = 30
    }
    status = "Enabled"
  }
}

# output bucket remote state
output "remote_state_bucket" {
  value = aws_s3_bucket.example.bucket
}

# Output bucket arn 
output "remote_state_bucket_arn" {
  value = aws_s3_bucket.example.arn
}

#################DynamoDB############################
#Active lock in on terraform.tfstate and prevent for doble access.
resource "aws_dynamodb_table" "terraform-lock" {
  name           = "my-example-bucket-roger"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = var.resource_tags
}

