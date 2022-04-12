terraform {
  backend "gcs" {
    bucket = "wooliesx-sre-exam-terraform-states"
    prefix = "gcp/core"
  }
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