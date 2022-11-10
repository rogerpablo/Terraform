variable "AWS_REGION" {
  description = "The AWS region your resources will be deployed"
}

variable "cidr_block" {
  description = "VPC's CIDR block."
  type        = string
  default     = "10.35.0.0/16"
}
variable "public_subnets" {
  description = "Public subnets list created on VPC."
  type        = list(string)
  default     = ["10.35.1.0/24", "10.35.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnets list created on VPC."
  type        = list(string)
  default     = ["10.35.3.0/24", "10.35.4.0/24"]
}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    Application = "Example-App",
    Environment = "Hml",
    Owner       = "Roger"
    Name        = "example"

  }
}




