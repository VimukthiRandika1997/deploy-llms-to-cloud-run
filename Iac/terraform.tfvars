project_id          = ""
region              = "us-central1"
network_name        = "prod-vpc"
public_subnet_name  = "subnet-public"
private_subnet_name = "subnet-private"
subnet_public_cidr  = "10.10.0.0/24"
subnet_private_cidr = "10.10.1.0/24"
labels              = { env = "prod", app = "core" }