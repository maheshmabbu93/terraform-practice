provider "aws" {
    region = "us-east-1" #desired region 
  
}
resource "aws_instance" "mahesh_tf" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t2.micro"

    tags = {
        Name = "tf-mahesh_tf"
    } 
}
