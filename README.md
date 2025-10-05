# deploy-llms-to-cloud-run
Experimenting with deploying production-grade llms to GCP Cloud Run

## Setting up GCP CLI: `gcloud`

- Login to your GCP account and set the projectID
	
	```ini
	gcloud auth login
	gcloud auth application-default login  # For local development
	gcloud config set project $PROJECT_ID
	```

## Create the GCP cloud resources

- First you need to create the **Cloud Run** service using the avaialble platforms
- Update `Iac/terraform.tfvars` file with your relevant `ENV` variable values

	1. Create cloud resources

		```ini
		bash scripts/create_resources.sh create
		```

- Destory cloud resources when the experiments are done

	```ini
	bash scripts/create_resources.sh destroy
	```

## Deploying Platforms

In this section, we'll experiment with different deployment platforms like vLLM, Ollama, TIG, etc.

### TIG Toolkit from Huggingface

- Please refer this: [more details](/platforms/TGI/README.md)