module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
}

module "subnet" {
  source            = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  vpc_id            = module.vpc.vpc_id
  avail_zone        = var.avail_zone
}

module "ec2_instance" {
  source     = "./modules/ec2_instance"
  subnet_id  = module.subnet.subnet_id
  avail_zone = var.avail_zone
  my_ip      = var.my_ip
  vpc_id     = module.vpc.vpc_id
}
