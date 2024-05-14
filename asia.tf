# Asia-Pacific VPC and subnet (RFC 1918 "192.168." range)
resource "google_compute_network" "asia_vpc" {
  name                    = "asia-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "asia_subnet" {
  name          = "asia-subnet"
  ip_cidr_range = "192.168.0.0/24"
  region        = var.asia_region
  network       = google_compute_network.asia_vpc.id
  private_ip_google_access = true
}

#create a vm for asia 
resource "google_compute_instance" "asia_vm" {
  name         = "asia-vm"
  machine_type = "e2-medium"
  zone         = "asia-east1-b"

  boot_disk {
    initialize_params {
     image = "projects/windows-cloud/global/images/windows-server-2022-dc-v20240415"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.asia_subnet.id

    access_config {
      // Allocate a public IP address

    }
  }


  
}



# Firewall rule to allow only port 3389 (RDP) traffic from Asia-Pacific region
resource "google_compute_firewall" "allow_rdp_from_asia" {
  name    = "allow-rdp-from-asia"
  network = google_compute_network.asia_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}
