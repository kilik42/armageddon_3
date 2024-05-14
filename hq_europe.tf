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

 metadata = {
    startup-script = <<-EOF
# Thanks to Remo
#!/bin/bash
# Update and install Apache2
apt update
apt install -y apache2

# Start and enable Apache2
systemctl start apache2
systemctl enable apache2

# GCP Metadata server base URL and header
METADATA_URL="http://metadata.google.internal/computeMetadata/v1"
METADATA_FLAVOR_HEADER="Metadata-Flavor: Google"

# Use curl to fetch instance metadata

# Create a simple HTML page and include instance details
cat <<EOF2 > /var/www/html/index.html
<html><body>
<h2>Welcome to your custom website.</h2>
<h3>Created with a direct input startup script!</h3>
<p><b>Instance Name:</b> $(hostname -f)</p>
<p><b>Instance Private IP Address: </b> $local_ipv4</p>
<p><b>Zone: </b> $zone</p>
<p><b>Project ID:</b> $project_id</p>
<p><b>Network Tags:</b> $network_tags</p>
</body></html>
EOF2
EOF
 }

}

# Firewall rule to deny all external access

# Firewall rule to allow only port 80 traffic from Americas regions to European subnet
resource "google_compute_firewall" "allow_http_for_europe" {
  name    = "allow-http-for-europe"
  network = google_compute_network.europe_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80","22"]
  }

  source_ranges = ["0.0.0.0/0", "35.235.240.0/20"]
  target_tags  = ["america-http-server","iap-ssh-allowed"]
}
