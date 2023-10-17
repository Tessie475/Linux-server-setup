terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "my_project_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet within the VPC
resource "aws_subnet" "my_project_subnet" {
  vpc_id     = aws_vpc.my_project_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# Create an internet gateway
resource "aws_internet_gateway" "my-project-igw" {
    vpc_id = aws_vpc.my_project_vpc.id
    tags = {
        Name: "my_project-ig"
    }
}

# Create a route table
resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = aws_vpc.my_project_vpc.default_route_table_id 

     route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-project-igw.id
    }
    tags = {
        Name: "my-project-main-rtb"
    }
}

# Configure instance to allow ingress traffic 
resource "aws_security_group" "my-project-sg" {
  name        = "my-project-sg"
  description = "Allows ingress traffic on port 22"
  vpc_id      = aws_vpc.my_project_vpc.id

  ingress {
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
    Name = "allow_all_ssh"
  }
}

# Create an EC2 instance within the subnet
data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}
    output "aws_ami_id" {
        value = data.aws_ami.latest-amazon-linux-image.id
    }

resource "aws_instance" "my_project_server" {
  ami = data.aws_ami.latest-amazon-linux-image.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_project_subnet.id
  vpc_security_group_ids = [aws_security_group.my-project-sg.id]
  availability_zone = "us-east-1a"

  associate_public_ip_address = true
  key_name = "linux-setup-project"
}

