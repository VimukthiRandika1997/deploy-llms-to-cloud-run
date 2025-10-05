variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Region for regional resources"
  type        = string
  default     = "us-central1"
}

variable "network_name" {
  description = "Name of the VPC"
  type        = string
  default     = "dev-vpc"
}

variable "subnet_public_cidr" {
  description = "CIDR for public subnet"
  type        = string
  default     = "10.10.0.0/24"
}

variable "subnet_private_cidr" {
  description = "CIDR for private subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "public_subnet_name" {
  type    = string
  default = "subnet-public"
}

variable "private_subnet_name" {
  type    = string
  default = "subnet-private"
}

variable "labels" {
  description = "Common labels"
  type        = map(string)
  default = {
    env = "prod"
  }
}

variable "artifact_registry_name" {
  type    = string
  default = "test-llm-deployment"
}

variable "cloud_run_service_name" {
  description = "Existing Cloud Run service name"
  type        = string
}

variable "lb_domain_name" {
  description = "Domain for the HTTPS Load Balancer"
  type        = string
  default     = "api.example.com" # Replace with your domain
}
