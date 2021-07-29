provider "aws" {
  region                  = var.region
  shared_credentials_file = file("${var.creds_path}")
}

data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.subnet_count)
}
/* Define VPC */
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  subnet_count = var.subnet_count
  azs          = local.azs

  tags = var.tags
}

module "ami" {
  source = "./modules/ami"
}

module "compute" {
  source         = "./modules/compute"
  ami_id         = module.ami.amazon_ami
  azs            = local.azs
  public_subnets = module.vpc.public_subnets
  public_sg      = module.vpc.public_sg
  app_subnets    = module.vpc.app_subnets
  app_sg         = module.vpc.app_sg
  tags           = var.tags
}
