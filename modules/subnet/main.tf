# Create a subnet within the VPC
resource "aws_subnet" "my_project_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
}