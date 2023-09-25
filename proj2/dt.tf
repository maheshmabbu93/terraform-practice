provider "aws" {
    region = "us-east-1"

  
}

resource "aws_vpc" "Terrafrom_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
}

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.Terrafrom_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true  
}

resource "aws_subnet" "sub2" {
    vpc_id = aws_vpc.Terrafrom_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
  
}

resource "aws_internet_gateway" "myigw" {
    vpc_id = aws_vpc.Terrafrom_vpc.id
  
}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.Terrafrom_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myigw.id
    }
  
}
resource "aws_route_table_association" "RT1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.RT.id
  
}

resource "aws_route_table_association" "RT2" {
    subnet_id = aws_subnet.sub2.id
    route_table_id = aws_route_table.RT.id
  
}

resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.Terrafrom_vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

resource "aws_s3_bucket" "example" {
    bucket = "mahesh93mabbu@"
  
}
resource "aws_instance" "terraform_instance" {
    ami = "ami-0261755bbcb8c4a84"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.webSg.id]
    subnet_id = aws_subnet.sub1.id

  
}

resource "aws_instance" "terraform_inst" {
    ami = "ami-0261755bbcb8c4a84"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.webSg.id]
    subnet_id = aws_subnet.sub2
    
  
}