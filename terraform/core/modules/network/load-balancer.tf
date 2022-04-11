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