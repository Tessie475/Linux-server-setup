# Configure instance to allow ingress traffic 
resource "aws_security_group" "my-project-sg" {
  name        = "my-project-sg"
  description = "Allows ingress traffic on port 2222"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2222
    to_port     = 2222
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
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
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.my-project-sg.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true
  key_name = "linux-setup-project"
}