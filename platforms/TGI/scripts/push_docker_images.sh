#!/bin/bash

# Create an artifact registry
gcloud artifacts repositories create $REPOSITORY_NAME \
    --repository-format=docker \
    --location=$REPOSITORY_REGOIN

# Make the configurations with created artifact registry
gcloud auth configure-docker $REPOSITORY_REGOIN-docker.pkg.dev

# Pull the docker image from the HF
docker pull us-docker.pkg.dev/deeplearning-platform-release/gcr.io/huggingface-text-generation-inference-cu121.2-2.ubuntu2204.py310
docker tag us-docker.pkg.dev/deeplearning-platform-release/gcr.io/huggingface-text-generation-inference-cu121.2-2.ubuntu2204.py310 \
    $REPOSITORY_REGOIN-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/huggingface-text-generation-inference:latest

# Push the docker image to the artifact registry
docker push $REPOSITORY_REGOIN-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME/huggingface-text-generation-inference:latest