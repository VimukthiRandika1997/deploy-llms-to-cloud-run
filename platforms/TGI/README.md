# Deploying TGI on Cloud Run

![TGI](https://huggingface.co/datasets/huggingface/documentation-images/resolve/main/TGI.png)

- Text Generation Inference (TGI) is a toolkit for deploying and serving LLM

- This framework enables high-performance text-generation for the most popular open-source models: *Llama, Gemma, Phi, T5, etc*


## How to run

### 1. Setup your `gcloud` CLI

- Please refer to the `README.md` file in the root directory
    - First CLI should be set up
    - Then the required GCP services should be enabled

### 2. Set the `ENV` variables

- Update the `ENV` variables in the script and execute it

    ```ini
    bash scripts/set_ENVs.sh
    ```

### 3. Push the Docker container to your Container Registry (GCR)

- Run this script

    ```ini
    bash scripts/push_docker_images.sh
    ```

### 4. Deploy to Cloud Run

- In this case, model weights are downloaded from the HF
- Run this command:

    ```ini
    bash scripts/deploy_to_cloud_run.sh
    ```

### 5. Add the Load Balancer to the cloud infrastructure

- Update `main.tf` file with below code snippets

  ```ini
  ##############################
  # Public HTTP Load Balancer  #
  ##############################

  # Reserve a global static IP for the LB
  # role: allocates a public static IP
  resource "google_compute_global_address" "lb_ip" {
    name = "${var.network_name}-lb-ip"
  }

  # Serverless Network Endpoint Group (NEG) — connects LB to Cloud Run
  # role: connects LB to Cloud Run
  resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
    name                  = "${var.network_name}-cloudrun-neg"
    region                = var.region
    network_endpoint_type = "SERVERLESS"

    cloud_run {
      service = var.cloud_run_service_name
    }
  }

  # Backend service that routes traffic to the Cloud Run NEG
  # role: defines backend routing target
  resource "google_compute_backend_service" "cloudrun_backend" {
    name                  = "${var.network_name}-backend"
    protocol              = "HTTP"
    load_balancing_scheme = "EXTERNAL_MANAGED"
    enable_cdn            = false

    backend {
      group = google_compute_region_network_endpoint_group.cloudrun_neg.id
    }

    log_config {
      enable = true
    }
  }

  # URL map — defines routing (you can add path-based rules here later)
  # role: defines URL -> backend mapping
  resource "google_compute_url_map" "cloudrun_url_map" {
    name            = "${var.network_name}-url-map"
    default_service = google_compute_backend_service.cloudrun_backend.id
  }

  # Target HTTP proxy (no SSL needed)
  # role: handles HTTP forwarding
  resource "google_compute_target_http_proxy" "http_proxy" {
    name    = "${var.network_name}-http-proxy"
    url_map = google_compute_url_map.cloudrun_url_map.id
  }

  # Global forwarding rule (public entry point)
  # role: listens on port 80 and routes traffic
  resource "google_compute_global_forwarding_rule" "http_rule" {
    name                  = "${var.network_name}-http-forwarding-rule"
    ip_protocol           = "TCP"
    port_range            = "80"
    target                = google_compute_target_http_proxy.http_proxy.id
    load_balancing_scheme = "EXTERNAL_MANAGED"
    ip_address            = google_compute_global_address.lb_ip.id
  }
  ```

- Then update `terraform.tfvars` file

  ```ini
  cloud_run_service_name=tgi-cloud-run
  ```

- Update the existing cloud infrastructure

  ```ini
  bash scripts/create_resources.sh create
  ```

## References

- [Huggingface TGI Toolkit](https://huggingface.co/docs/text-generation-inference/en/index)
- [Huggingface Blog For Deploying Models in GCP Cloud Run](https://huggingface.co/docs/google-cloud/examples/cloud-run-deploy-llama-3-1-on-cloud-run)

- [Reference Implementation](https://github.com/richardhe-fundamenta/practical-gcp-examples/tree/main/tgi-cloud-run)