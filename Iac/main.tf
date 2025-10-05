#################
# Network layer #
#################

# VPC
resource "google_compute_network" "vpc" {
  name                            = var.network_name
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
  routing_mode                    = "GLOBAL"
}

# Public Subnet
resource "google_compute_subnetwork" "public" {
  name                     = var.public_subnet_name
  ip_cidr_range            = var.subnet_public_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  stack_type               = "IPV4_ONLY"
  private_ip_google_access = true
  purpose                  = "PRIVATE"
}

# Private Subnet
resource "google_compute_subnetwork" "private" {
  name                     = var.private_subnet_name
  ip_cidr_range            = var.subnet_private_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  stack_type               = "IPV4_ONLY"
  private_ip_google_access = true
  purpose                  = "PRIVATE"
}

#########################
# Cloud Router &  NAT   #
#########################

# Cloud Router
resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id

  bgp {
    asn = 64514
  }
}

# Cloud NAT
resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

##############################
# Firewall – least privilege #
##############################

# Allow interal traffic within only the network (only within this VPC)
# - public and private subnets can communicate with each other without an issue
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.network_name}-allow-internal"
  network = google_compute_network.vpc.name

  direction = "INGRESS"
  priority  = 65534

  source_ranges = ["10.10.0.0/16"] # tighten to exact subnets if preferred

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}
