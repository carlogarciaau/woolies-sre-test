resource "google_compute_firewall" "webserver" {
  ## firewall rules enabling the load balancer health checks
  name    = "webserver-firewall"
  network = "vpc"

  description = "allow Google health checks and network load balancers access"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = var.allowed_ports_for_health_checks
  }

  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}
