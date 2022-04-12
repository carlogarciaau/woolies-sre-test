module "vpc" {
  source                = "./modules/vpc"
  public_subnet_region  = var.region
  private_subnet_region = var.region
}

module "compute" {
  source     = "./modules/compute"
  depends_on = [module.vpc]
}

module "network" {
  source     = "./modules/network"
  depends_on = [module.compute]
  region     = var.region
}

module "k8s-cluster" {
  source     = "./modules/k8s-cluster"
  depends_on = [module.vpc]
  project    = var.project
  region     = var.region
}

module "ansible-service-account" {
  source = "./modules/ansible-service-account"
}