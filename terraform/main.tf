module "vpc" {
  source                = "./modules/vpc"
  public_subnet_region  = var.region
  private_subnet_region = var.region
}

module "compute" {
  source     = "./modules/compute"
  depends_on = [module.vpc]
  region     = var.region
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
  source  = "./modules/ansible-service-account"
  project = var.project
}

resource "google_storage_bucket" "nginx_conf" {
  name          = "wooliesx-sre-exam-nginx-conf"
  location      = "ASIA"
  force_destroy = true
}

resource "google_storage_bucket_access_control" "nginx_conf_rule" {
  bucket     = google_storage_bucket.nginx_conf.name
  role       = "WRITER"
  entity     = "user-${module.ansible-service-account.sa_email}"
  depends_on = [module.ansible-service-account]
}