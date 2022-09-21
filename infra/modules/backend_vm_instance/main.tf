module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  network = var.network
  project_id =  var.project
  region     = var.region 
  create_router = true
  router     = "nat-router" 
  router_asn = "64514"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_instance" "privatevm" {
  project      = var.project
  name         = "default-vm"
  machine_type = var.machine_type
  zone         = var.zone

  metadata_startup_script = "${file("${path.module}/startup.sh")}" 
  boot_disk {
    initialize_params {
      image = "projects/rhel-cloud/global/images/rhel-8-v20220126"
      size = "20"
    }
  }
  
  network_interface { 
    subnetwork = var.subnetwork
  }
  service_account {
    scopes = ["cloud-platform"]
  }
}