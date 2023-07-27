variable "region" {
  description = "AWS Region"
}

## Networking

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnet_cidr" {
    description = "The CIDR block for the public subnet"
}

variable "private_subnet_cidr" {
    description = "The CIDR block for the private subnet"
}
