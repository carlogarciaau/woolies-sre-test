terraform {
  required_providers {
    google = {
      version = "~> 4.16.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

resource "google_storage_bucket" "terraform_state" {
  name     = var.backend_bucket
  location = "ASIA"
}

resource "google_storage_bucket" "nginx_conf" {
  name     = var.nginx_conf_bucket
  location = "ASIA"
}