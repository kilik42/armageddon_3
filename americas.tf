# VPC and subnet for first Americas region (RFC 1918 "172.16." range)
resource "google_compute_network" "america_vpc_1" {
  name                    = "america-vpc-1"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "america_subnet_1" {
  name          = "america-subnet-1"
  ip_cidr_range = "172.16.0.0/24"
  region        = var.america_region_1
  network       = google_compute_network.america_vpc_1.id
}

# VPC and subnet for second Americas region (RFC 1918 "172.16." range)
# resource "google_compute_network" "america_vpc_2" {
#   name                    = "america-vpc-2"
#   auto_create_subnetworks = false
# }

resource "google_compute_subnetwork" "america_subnet_2" {
  name          = "america-subnet-2"
  ip_cidr_range = "172.16.1.0/24"
  region        = var.america_region_2
  network       = google_compute_network.america_vpc_1.id
}

# Peering connections to the European HQ VPC
resource "google_compute_network_peering" "america_to_europe" {
  name         = "america-to-europe-1"
  network      = google_compute_network.america_vpc_1.id
  peer_network = google_compute_network.europe_vpc.self_link
}

resource "google_compute_network_peering" "europe_to_america" {
  name         = "europe-to-america-1"
  network      = google_compute_network.europe_vpc.id
  peer_network = google_compute_network.america_vpc_1.self_link
}

# Firewall rule to allow only port 80 traffic from Americas regions to European subnet
resource "google_compute_firewall" "allow_http_from_america" {
  name    = "allow-http-from-america"
  network = google_compute_network.europe_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["172.16.0.0/24", "172.16.1.0/24"]
}
