resource "google_compute_global_address" "lb-ip" {
  name         = "lb-ip"
  project      = var.project
  address_type = "EXTERNAL"
}

resource "google_compute_global_forwarding_rule" "http" {
  project    = var.project
  name       = "http-fr"
  port_range = "80"
  ip_address = google_compute_global_address.lb-ip.address
  target     = google_compute_target_http_proxy.default.self_link
}

resource "google_compute_target_http_proxy" "default" {
  project = var.project
  name    = "http-proxy"
  url_map = google_compute_url_map.default.self_link
}

resource "google_compute_url_map" "default" {
  project         = var.project
  name            = "http"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_health_check" "default" {
  project            = var.project
  name               = "health-check"
  check_interval_sec = 10
  timeout_sec        = 1
  http_health_check {
    port = "80"
  }

}

resource "google_compute_backend_service" "backend" {
  health_checks         = [google_compute_health_check.default.self_link]
  load_balancing_scheme = "EXTERNAL"
  project               = var.project
  name                  = "backend"
  port_name             = "http"
  backend {
    group = var.instance-group
  }

}

resource "google_compute_firewall" "allow_health_check" {
  name        = "lb-health-check"
  description = "lb-health-check"
  project     = var.project
  direction   = "INGRESS"
  network     = var.network
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags   = [var.vm_tag]
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}