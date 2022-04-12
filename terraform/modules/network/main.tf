resource "google_compute_global_address" "webserver" {
  name = "webserver-global-address"
}

resource "google_compute_global_forwarding_rule" "webserver" {
  name       = "webserver-forwarding-rule-80"
  port_range = var.forwarding_rule_port_range
  target     = google_compute_target_http_proxy.webserver.self_link
}

resource "google_compute_url_map" "webserver" {
  name            = "webserver-url-map"
  default_service = "webserver-backend"
}

resource "google_compute_target_http_proxy" "webserver" {
  name    = "webserver-target-http-proxy"
  url_map = google_compute_url_map.webserver.self_link
}


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

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = "vpc"

  description = "allow ssh"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.source_ranges
  target_tags   = var.target_tags
}