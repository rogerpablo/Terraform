#remote backend -- Is necessary create to bucket previous 
terraform {
  backend "s3" {
    bucket         = "my-example-bucket-roger"
    key            = "vpc-example/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-example-bucket-roger"
  }
}
