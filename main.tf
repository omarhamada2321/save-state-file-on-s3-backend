provider "aws" {
  region = var.myRegion
}

resource "aws_instance" "web" {
  ami = var.myami
  instance_type = var.myinstancetype
  key_name= var.key_name
  vpc_security_group_ids = [aws_security_group.SG_OM.id]
  tags = {
  Name = "production"
    }



}

resource "aws_security_group" "SG_OM" {
  name        = "SG_OM"
  description = "Allow ssh only"
 

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_tls"
  }
}






resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
   public_key = file(var.public_key)
}

output "instance_ip_addr" {
  value       = aws_instance.web.private_ip
  description = "The private IP address of the main server instance."
}

output "instance_ip_addr_public" {
  value       = aws_instance.web.public_ip
  description = "The public IP address of the main server instance."
}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket15555"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
terraform {
  backend "s3" {
    bucket   = "my-tf-test-bucket15555"
    key      = "terraform-state"
    region   = "us-east-1"
  }

}

