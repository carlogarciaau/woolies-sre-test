resource "google_service_account" "web_server_sa" {
  account_id   = "web-server-service-account-id"
  display_name = "Web Server Service Account"
}

resource "google_compute_instance_template" "webserver" {
  name                 = "web-server-template"
  description          = "Compute instance template for creating web server instances."
  tags                 = ["web-server"]
  instance_description = "Web server instance"
  machine_type         = var.machine_type

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = "vpc"
    subnetwork = var.subnetwork
    access_config {}
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.web_server_sa.email
    scopes = ["cloud-platform"]
  }

  depends_on = [google_project_service.compute]

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "webserver_igm" {
  name = "webserver-igm"

  base_instance_name = "webserver"
  region             = "australia-southeast1"

  version {
    instance_template = google_compute_instance_template.webserver.id
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.http_health_check.self_link
    initial_delay_sec = 10
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_autoscaler" "webserver_autoscaler" {
  name   = "webserver-autoscaler"
  region = "australia-southeast1"
  target = google_compute_region_instance_group_manager.webserver_igm.id

  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

resource "google_compute_health_check" "http_health_check" {
  name = "http-health-check"

  timeout_sec         = 60
  check_interval_sec  = 120
  healthy_threshold   = 3
  unhealthy_threshold = 10

  http_health_check {
    request_path = "/"
    port         = 80
  }
}

resource "google_compute_backend_service" "webserver_backend" {
  name             = "webserver-backend"
  protocol         = "HTTP"
  timeout_sec      = 10
  session_affinity = "NONE"

  backend {
    group = google_compute_region_instance_group_manager.webserver_igm.instance_group
  }

  health_checks = ["${google_compute_health_check.http_health_check.self_link}"]
}

# Enable compute API
resource "google_project_service" "compute" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}
