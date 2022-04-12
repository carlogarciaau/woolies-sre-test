# Enable container api
resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project}-gke"
  location = var.region

  network    = var.vpc_name
  subnetwork = var.subnet_name

  # Enabling Autopilot for this cluster
  enable_autopilot = true

  # Workaround for https://github.com/hashicorp/terraform-provider-google/issues/10782
  ip_allocation_policy {
  }

  depends_on = [google_project_service.container]
}