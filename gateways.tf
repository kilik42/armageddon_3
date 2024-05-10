resource google_compute_vpn_gateway "europe_vpn_gateway" {
  name    = "europe-vpn-gateway"
  network = google_compute_network.europe_vpc.id
  region  = var.europe_region
}

resource google_compute_address "europe_vpn_gateway_ip" {
  name = "europe-vpn-gateway-ip"
  region = var.europe_region
}

resource google_compute_forwarding_rule "europe_vpn_gateway_forwarding_rule" {
  name = "europe-vpn-gateway-forwarding-rule"
  region = var.europe_region
  ip_address = google_compute_address.europe_vpn_gateway_ip.address
  target = google_compute_vpn_gateway.europe_vpn_gateway.self_link
  port_range = "500" 
  ip_protocol = "UDP"
}

resource google_compute_forwarding_rule "europe_vpn_gateway_forwarding_rule_2" {
  name = "europe-vpn-gateway-forwarding-rule-2"
  region = var.europe_region
  ip_address = google_compute_address.europe_vpn_gateway_ip.address
  target = google_compute_vpn_gateway.europe_vpn_gateway.self_link

  ip_protocol = "ESP"
}

resource google_compute_forwarding_rule "europe_vpn_forwarding_rule_3"{
    name = "europe-vpn-forwarding-rule-3"
    region = var.europe_region
    ip_address = google_compute_address.europe_vpn_gateway_ip.address
    target = google_compute_vpn_gateway.europe_vpn_gateway.self_link
    port_range = "4500"
    ip_protocol = "UDP"
}

resource google_compute_vpn_tunnel "europe_vpn_tunnel" {
  name = "europe-vpn-tunnel"
  peer_ip = google_compute_address.asia_vpn_gateway_ip.address
  region = var.europe_region
  target_vpn_gateway = google_compute_vpn_gateway.europe_vpn_gateway.self_link
  shared_secret = "mysecret"
  vpn_gateway_interface = "0"
  local_traffic_selector = [google_compute_subnetwork.europe_subnet.ip_cidr_range]
    remote_traffic_selector = [ google_compute_subnetwork.asia_subnet.ip_cidr_range]

    depends_on = [ google_compute_forwarding_rule.europe_vpn_forwarding_rule_3, google_compute_forwarding_rule.europe_vpn_gateway_forwarding_rule_2, google_compute_forwarding_rule.europe_vpn_gateway_forwarding_rule]
}

resource google_compute_route "europe_vpn_route" {
  name = "europe-vpn-route"
  network = google_compute_network.europe_vpc.id
  dest_range = google_compute_subnetwork.asia_subnet.ip_cidr_range
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.europe_vpn_tunnel.self_link
  depends_on = [ google_compute_vpn_tunnel.europe_vpn_tunnel ]
}


resource google_compute_vpn_gateway "asia_vpn_gateway" {
  name   = "asia-vpn-gateway"
  region = var.asia_region
  network = google_compute_network.asia_vpc.id
  depends_on = [ google_compute_route.europe_vpn_route ]
}

resource google_compute_address "asia_vpn_gateway_ip" {
  name = "asia-vpn-gateway-ip"
  region = var.asia_region
}

resource google_compute_forwarding_rule "asia_vpn_gateway_forwarding_rule" {
  name = "asia-vpn-gateway-forwarding-rule"
  region = var.asia_region
  ip_address = google_compute_address.asia_vpn_gateway_ip.address
  target = google_compute_vpn_gateway.asia_vpn_gateway.self_link
  port_range = "500"
  ip_protocol = "UDP"
}

resource google_compute_forwarding_rule "asia_vpn_gateway_forwarding_rule_2" {
  name = "asia-vpn-gateway-forwarding-rule-2"
  region = var.asia_region
  ip_address = google_compute_address.asia_vpn_gateway_ip.address
  target = google_compute_vpn_gateway.asia_vpn_gateway.self_link

  ip_protocol = "ESP"
}

resource google_compute_forwarding_rule "asia_vpn_forwarding_rule_3"{
    name = "asia-vpn-forwarding-rule-3"
    region = var.asia_region
    ip_address = google_compute_address.asia_vpn_gateway_ip.address
    target = google_compute_vpn_gateway.asia_vpn_gateway.self_link
    port_range = "4500"
    ip_protocol = "UDP"
}

resource google_compute_vpn_tunnel "asia_vpn_tunnel" {
  name = "asia-vpn-tunnel"
  peer_ip = google_compute_address.europe_vpn_gateway_ip.address
  region = var.asia_region
  target_vpn_gateway = google_compute_vpn_gateway.asia_vpn_gateway.self_link
  shared_secret = "mysecret"
  vpn_gateway_interface = "0"
  local_traffic_selector = [google_compute_subnetwork.asia_subnet.ip_cidr_range]
  remote_traffic_selector = [ google_compute_subnetwork.europe_subnet.ip_cidr_range]

  depends_on = [ google_compute_forwarding_rule.asia_vpn_forwarding_rule_3, google_compute_forwarding_rule.asia_vpn_gateway_forwarding_rule_2, google_compute_forwarding_rule.asia_vpn_gateway_forwarding_rule]
}

resource google_compute_route "asia_vpn_route" {
  name = "asia-vpn-route"
  network = google_compute_network.asia_vpc.id
  dest_range = google_compute_subnetwork.europe_subnet.ip_cidr_range
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.asia_vpn_tunnel.self_link
  depends_on = [ google_compute_vpn_tunnel.asia_vpn_tunnel ]
}

