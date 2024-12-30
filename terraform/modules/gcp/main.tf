# Network
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.network_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.vpc.id
  region        = var.region
}

# Firewall rules
resource "google_compute_firewall" "ad_rules" {
  name    = "ad-firewall-rules"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["53", "389", "3389"]
  }

  source_ranges = [var.subnet_cidr]
  target_tags   = ["ad-server"]
}

resource "google_compute_firewall" "db_rules" {
  name    = "db-firewall-rules"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["1433"]
  }

  source_tags = ["ad-server"]
  target_tags = ["db-server"]
}

# Compute instances
resource "google_compute_instance" "ad_server" {
  name         = var.ad_instance_name
  machine_type = var.machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2019"
      size  = 100
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
  }

  tags = ["ad-server"]

  metadata = {
    windows-startup-script-ps1 = "Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools"
  }
}

resource "google_compute_instance" "db_server" {
  name         = var.db_instance_name
  machine_type = var.machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-2019"
      size  = 100
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id
  }

  tags = ["db-server"]
}