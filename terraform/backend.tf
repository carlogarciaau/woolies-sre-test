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