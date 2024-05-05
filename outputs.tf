# Outputs for Europe (HQ)
output "europe_vpc" {
  value = google_compute_network.europe_vpc.name
}

output "europe_subnet" {
  value = google_compute_subnetwork.europe_subnet.name
}

# Outputs for Americas
output "america_vpc_1" {
  value = google_compute_network.america_vpc_1.name
}

output "america_vpc_2" {
  value = google_compute_network.america_vpc_2.name
}

# Outputs for Asia-Pacific
output "asia_vpc" {
  value = google_compute_network.asia_vpc.name
}

output "asia_subnet" {
  value = google_compute_subnetwork.asia_subnet.name
}
