resource "aws_instance" "Ubuntu" {
   ami           = var.AMIS[var.AWS_REGION]
   instance_type = "t2.micro"
}

