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
}

# # VPN connection to European HQ
# resource "google_compute_vpn_gateway" "asia_vpn_gateway" {
#   name   = "asia-vpn-gateway"
#   region = var.asia_region
#   network = google_compute_network.asia_vpc.id
#   #static ip address

# }
# # resource google compute address
# resource "google_compute_address" "asia_vpn_gateway_ip" {
#   name = "asia-vpn-gateway-ip"
#   region = var.asia_region
  
# }

# resource google_compute_forwarding_rule "asia_vpn_gateway_forwarding_rule" {
#   name = "asia-vpn-gateway-forwarding-rule"
#   region = var.asia_region
#   ip_address = google_compute_address.asia_vpn_gateway_ip.address
#   target = google_compute_vpn_gateway.asia_vpn_gateway.self_link
#   port_range = "4500"
#   ip_protocol = "UDP"
# }

# resource google_compute_forwarding_rule "asia_vpn_gateway_forwarding_rule_2" {
#   name = "asia-vpn-gateway-forwarding-rule-2"
#   region = var.asia_region
#   ip_address = google_compute_address.asia_vpn_gateway_ip.address
#   target = google_compute_vpn_gateway.asia_vpn_gateway.self_link

#   ip_protocol = "ESP"
# }



# # European VPN Gateway (HQ)
# resource "google_compute_vpn_gateway" "europe_vpn_gateway" {
#   name    = "europe-vpn-gateway"
#   network = google_compute_network.europe_vpc.id
#   region  = var.europe_region
# }

# resource google_compute_address "europe_vpn_gateway_ip" {
#   name = "europe-vpn-gateway-ip"
#   region = var.europe_region
# }

# resource google_compute_forwarding_rule "europe_vpn_gateway_forwarding_rule" {
#   name = "europe-vpn-gateway-forwarding-rule"
#   region = var.europe_region
#   ip_address = google_compute_address.europe_vpn_gateway_ip.address
#   target = google_compute_vpn_gateway.europe_vpn_gateway.self_link
#   port_range = "4500"
#   ip_protocol = "UDP"
# }

# resource google_compute_forwarding_rule "europe_vpn_gateway_forwarding_rule_2" {
#   name = "europe-vpn-gateway-forwarding-rule-2"
#   region = var.europe_region
#   ip_address = google_compute_address.europe_vpn_gateway_ip.address
#   target = google_compute_vpn_gateway.europe_vpn_gateway.self_link

#   ip_protocol = "ESP"
# }

# # Example of VPN Tunnel configuration
# resource "google_compute_vpn_tunnel" "europe_to_asia_tunnel" {
#   name          = "europe-to-asia-tunnel"
#   region        = var.europe_region
#   # vpn_gateway   = google_compute_vpn_gateway.asia_vpn_gateway.id
#   target_vpn_gateway = google_compute_vpn_gateway.europe_vpn_gateway.self_link
#   shared_secret = sensitive("women_and_bears_belong_together" ) 
#   depends_on = [ google_compute_forwarding_rule.europe_vpn_gateway_forwarding_rule, google_compute_forwarding_rule.europe_vpn_gateway_forwarding_rule_2]
# }



# # tunnel for europe to asia
# resource "google_compute_vpn_tunnel" "asia_to_europe_tunnel" {
#   name          = "asia-to-europe-tunnel"
#   region        = var.asia_region
#   # vpn_gateway   = google_compute_vpn_gateway.europe_vpn_gateway.id
#   target_vpn_gateway = google_compute_vpn_gateway.asia_vpn_gateway.self_link
#   shared_secret = sensitive("women_and_bears_belong_together" ) 
#   depends_on = [ google_compute_forwarding_rule.asia_vpn_gateway_forwarding_rule, google_compute_forwarding_rule.asia_vpn_gateway_forwarding_rule_2]
# }
# Firewall rule to allow only port 3389 (RDP) traffic from Asia-Pacific region
resource "google_compute_firewall" "allow_rdp_from_asia" {
  name    = "allow-rdp-from-asia"
  network = google_compute_network.europe_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["192.168.0.0/24"]
}
