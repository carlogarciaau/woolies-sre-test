module "vpc" {
  source = "./modules/vpc"
}

module "compute" {
  source     = "./modules/compute"
  depends_on = [module.vpc]
}

module "network" {
  source     = "./modules/network"
  depends_on = [module.compute]
}

module "k8s-cluster" {
  source     = "./modules/k8s-cluster"
  depends_on = [module.vpc]
}