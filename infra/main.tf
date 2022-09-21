locals {
  required_apis = [
    "compute.googleapis.com",
    "container.googleapis.com"
  ]
  env_vars_k8s = {
    PROJECT_ID   = var.project
    CLUSTER_NAME = var.cluster_name
    REGION       = var.region
    SA_KEY       = data.google_secret_manager_secret_version.SA-KEY.secret_data
  }
}

data "google_secret_manager_secret_version" "SA-KEY" {
  secret  = "SA-KEY"
  project = var.project
}

resource "google_project_service" "apis" {
  for_each = toset(local.required_apis)

  project            = var.project
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_network" "custom-vpc" {
  name                    = "custom-vpc"
  project                 = var.project
  auto_create_subnetworks = false
  depends_on = [
    google_project_service.apis
  ]
}

resource "google_compute_subnetwork" "autopilot-subnet" {
  name          = "autopilot-subnet"
  region        = var.region
  network       = google_compute_network.custom-vpc.id
  ip_cidr_range = "10.10.10.0/24"
  project       = var.project


  secondary_ip_range = [
    {
      range_name    = "services"
      ip_cidr_range = "10.10.11.0/24"
    },
    {
      range_name    = "pods"
      ip_cidr_range = "10.1.0.0/20"
    }
  ]
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "vm-subnet" {
  name                     = "vm-subnet"
  region                   = var.region
  network                  = google_compute_network.custom-vpc.id
  ip_cidr_range            = "10.10.14.0/24"
  project                  = var.project
  private_ip_google_access = true
}


resource "google_compute_global_address" "gke-ip" {
  name         = "gke-ip"
  project      = var.project
  address_type = "EXTERNAL"
  depends_on = [
    google_project_service.apis
  ]
}

module "autopilot-gke" {
  source                             = "./modules/k8s"
  cluster_name                       = var.cluster_name
  cluster_region                     = var.region
  project                            = var.project
  network                            = google_compute_network.custom-vpc.name
  subnetwork                         = google_compute_subnetwork.autopilot-subnet.id
  cluster_gke_master_ipv4_cidr_block = "172.23.0.0/28"
  env_vars_k8s                       = local.env_vars_k8s
}

module "backend" {
  source     = "./modules/backend_vm_instance"
  region     = var.region
  project    = var.project
  network    = google_compute_network.custom-vpc.id
  subnetwork = google_compute_subnetwork.vm-subnet.id
  vm_tag     = var.vm_tag
  zone       = var.zone
}

module "load_balancer" {
  source         = "./modules/lb_for_vm"
  project        = var.project
  instance-group = module.backend.self-link
  network        = google_compute_network.custom-vpc.self_link
  vm_tag         = var.vm_tag
}