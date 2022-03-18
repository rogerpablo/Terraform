variable "myvar" {
   type = string
   default = "hello word"
}

variable "mylist" {
   type = list
   default = [1,2,3]
}

variable "mymap" {
   type = map(string)
   default = {
   mykey = "myvalue" 
   }
}

variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "AMIS" {
   type = map(string)
   default = {
   eu-west-1 = "ami-047bb4163c506cd98"
   }
}

variable "AWS_ACCESS_KEY" {
  default = "AKIA4NFCHVJO4RPDXJWW"
}

variable "AWS_SECRET_KEY" {
  default = "ub+LWteSEfakKSYC7r3cAbdKPV849JL7huaGIcLD"
}


