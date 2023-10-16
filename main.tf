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

  associate_public_ip_address = true
  key_name = "my-project"
}
