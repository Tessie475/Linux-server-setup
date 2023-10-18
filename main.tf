variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}


# Create a VPC
resource "aws_vpc" "my_project_vpc" {
  cidr_block = var.vpc_cidr_block
}

# Create a subnet within the VPC
resource "aws_subnet" "my_project_subnet" {
  vpc_id     = aws_vpc.my_project_vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
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
  description = "Allows ingress traffic on port 2222"
  vpc_id      = aws_vpc.my_project_vpc.id

  ingress {
    from_port   = 2222
    to_port     = 2222
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
resource "aws_instance" "my_project_server" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_project_subnet.id
  vpc_security_group_ids = [aws_security_group.my-project-sg.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true
  key_name = "linux-setup-project"
}