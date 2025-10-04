export PROJECT_ID=<your-project-id>
export LOCATION=us-central1 # or any location where Cloud Run offers GPUs: https://cloud.google.com/run/docs/locations#gpu
export CONTAINER_URI=us-docker.pkg.dev/deeplearning-platform-release/gcr.io/huggingface-text-generation-inference-cu121.2-2.ubuntu2204.py310
export SERVICE_NAME=text-generation-inference