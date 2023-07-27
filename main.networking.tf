module "networking" {
  source = "./modules/networking"

  region               = var.region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_subnet_id" {
  value = module.networking.public_subnet_id
}

output "private_subnet_id" {
  value = module.networking.private_subnet_id
}

output "default_sg_id" {
  value = module.networking.default_sg_id
}

