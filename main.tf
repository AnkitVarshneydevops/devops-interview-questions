provider "aws" {
  region = var.region
}

module "vpc" {
  source             = "./vpc"
  name               = var.name
  environment        = var.environment
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
}

module "bastion" {
  source           = "./bastion"
  name             = var.name
  environment      = var.environment
  vpc              = module.vpc.id
  instance_type    = var.bastion_instance_type
  public_subnet_id = module.vpc.public_subnets[0].id
  aws_region       = var.region
  ec2_sg_group_id  = module.sg.ec2_sg_group_id

}

module "sg" {
  source      = "./security-group"
  name        = var.name
  environment = var.environment
  vpc         = module.vpc.id
}