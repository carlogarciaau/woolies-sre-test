resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  description             = var.vpc_description
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"

  depends_on = [google_project_service.compute]
}

# Public Subnet
resource "google_compute_subnetwork" "public_subnet" {
  ip_cidr_range            = var.cidr_public
  name                     = var.public_subnet_name
  network                  = google_compute_network.vpc_network.self_link
  description              = var.public_subnet_description
  region                   = var.public_subnet_region
  private_ip_google_access = false
}

# Private Subnet
resource "google_compute_subnetwork" "private_subnet" {
  ip_cidr_range            = var.cidr_private
  name                     = var.private_subnet_name
  network                  = google_compute_network.vpc_network.self_link
  description              = var.private_subnet_description
  region                   = var.private_subnet_region
  private_ip_google_access = true
}

# Enable compute API
resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_router" "router" {
  name    = "router"
  region  = var.private_subnet_region
  network = google_compute_network.vpc_network.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-gateway"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}