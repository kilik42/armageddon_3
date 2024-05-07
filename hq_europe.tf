# European VPC and subnet (RFC 1918 "10." range)
resource "google_compute_network" "europe_vpc" {
  name                    = "europe-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "europe_subnet" {
  name          = "europe-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.europe_region
  network       = google_compute_network.europe_vpc.id
}

# VM for the prototype gaming homepage
resource "google_compute_instance" "europe_vm" {
  name         = "europe-vm"
  machine_type = "e2-medium"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.europe_subnet.id
  }

  metadata_startup_script = <<-EOF
  #!/bin/bash
  apt-get update
  apt-get install -y apache2
  echo '<html><body><h1>Welcome to the European HQ Gaming Homepage</h1></body></html>' > /var/www/html/index.html
  EOF
}

# Firewall rule to deny all external access
resource "google_compute_firewall" "deny_external" {
  name    = "deny-external"
  network = google_compute_network.europe_vpc.id

  direction = "INGRESS"
  priority  = 1000

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}
