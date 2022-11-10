variable "aws_region" {

  type        = string
  description = ""
  default     = "us-east-1"

}

variable "resource_tags" {
  description = "Tags to set for all resources"
  type        = map(string)
  default = {
    Application = "Example-APP",
    Environment = "Hml",
    Owner       = "Roger"
    Name        = "Example"

  }
}
