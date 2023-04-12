terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"
    }
  }
}

#provider "aws" {
# Configuration
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIARHTNVLSWFYOGELVR"
  secret_key = "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"

}

resource "aws_instance" "web" {
  ami                         = var.instance_ami
  instance_type               = var.instance_size
  key_name                    = "my-aws-key"
  vpc_security_group_ids      = [aws_security_group.terraform.id]
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  user_data                   = <<-EOF
   #!/bin/bash
   sudo yum install -y httpd
   sudo systemctl start httpd
   sudo systemctl enable httpd
   echo "<h1>Deployed ec2 instance with Terraform </h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    Name = "web"
  }
}
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_security_group" "terraform" {
  name        = "terraform"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = var.sg[0]
    to_port     = var.sg[0]
    protocol    = "tcp"
    cidr_blocks = [var.sg_cidr]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  ingress {
    from_port   = var.sg[1]
    to_port     = var.sg[1]
    protocol    = "tcp"
    cidr_blocks = [var.sg_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.sg_cidr]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform"
  }
}


resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr

  tags = {
    Name = "main"
  }
}



resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "gw"
  }
}
resource "aws_route_table" "gw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table_association" "public_rt_asso" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.gw.id
}
