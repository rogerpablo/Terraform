##################################Providers###################################
terraform {
  # Mandatory terraform version - 1.3.1 is the last version on 04/10/2022
  required_version = "~>1.3.0"

  # providers - 4.33.0 the last version on 04/10/2022
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.57.0"
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
resource "aws_s3_bucket" "remote-state" {
  bucket = "my-example-roger-pablo"
  tags   = var.resource_tags
}

#block whole  public acess possibilities
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.remote-state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


#Encrypt bucket With SSE-S3
resource "aws_s3_bucket_server_side_encryption_configuration" "remote-state" {
  bucket = aws_s3_bucket.remote-state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#Active versioning on bucket
resource "aws_s3_bucket_versioning" "remote-state" {
  bucket = aws_s3_bucket.remote-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

#Lifecycle for version archives 
resource "aws_s3_bucket_lifecycle_configuration" "remote-state" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.remote-state]
  bucket     = aws_s3_bucket.remote-state.bucket
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
  value = aws_s3_bucket.remote-state.bucket
}

# Output bucket arn 
output "remote_state_bucket_arn" {
  value = aws_s3_bucket.remote-state.arn
}

#################DynamoDB############################
#Active lock in on terraform.tfstate and prevent for doble access.
resource "aws_dynamodb_table" "terraform-lock" {
  name           = "my-example-roger-pablo"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  
  server_side_encryption {
    enabled = true
  }
  point_in_time_recovery {
    enabled = true
  }
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }
}
