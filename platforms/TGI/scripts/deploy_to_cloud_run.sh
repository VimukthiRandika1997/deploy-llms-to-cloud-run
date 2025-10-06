/*

- In this case, the model weights are downloaded from Huggingface via the Internet
- If we are accessing models which requires consent, then we may need to use a access token from a HF account

*/

gcloud beta run deploy $SERVICE_NAME \
    --image=$CONTAINER_URI \
    --set-env-vars=HF_HUB_ENABLE_HF_TRANSFER=1 \
    --args="--model-id=$LLM_MODEL, --max-concurrent-requests=64" \
    --port=8080 \
    --cpu=8 \
    --memory=32Gi \
    --no-cpu-throttling \
    --gpu=1 \
    --gpu-type=nvidia-l4 \
    --max-instances=3 \
    --concurrency=64 \
    --region=$LOCATION \
    --network=$VPC \
    --subnet=$SUBNET \
    --vpc-egress=all-traffic \
    --no-allow-unauthenticated