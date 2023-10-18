variable "vpc_cidr_block" {
    description = "VPC CIDR block"
    type        = string
}

variable "subnet_cidr_block" {
    description = "The subnet CIDR BLOCK"
    type        = string
}

variable "avail_zone" {
    description = "The availability zone"
    type        = string
}

variable "my_ip" {
    description = "My IP Address"
    type        = string
}