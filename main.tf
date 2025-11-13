##########################
# NETWORK MODULE
##########################
module "network" {
  source   = "./modules/network"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  subnets  = var.subnets
}

##########################
# SECURITY GROUPS MODULE
##########################
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.network.vpc_id
}

##########################
# EC2 MODULE
##########################
module "ec2" {
  source    = "./modules/ec2"
  instances = var.instances

  # Pass subnet IDs map from network module
  subnets = module.network.subnet_ids

  # Pass SG IDs from security module
  web_sg_id = module.security_groups.web_sg_id
  db_sg_id  = module.security_groups.db_sg_id
}

##########################
# OUTPUTS
##########################
output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

output "web_sg_id" {
  value = module.security_groups.web_sg_id
}

output "db_sg_id" {
  value = module.security_groups.db_sg_id
}

output "web_instance_public_ip" {
  value = module.ec2.web_instance_public_ip
}

output "db_instance_private_ip" {
  value = module.ec2.db_instance_private_ip
}