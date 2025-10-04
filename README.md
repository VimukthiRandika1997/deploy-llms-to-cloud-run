# deploy-llms-to-cloud-run
Experimenting with deploying production-grade llms to GCP Cloud Run

## Setting up GCP CLI: `gcloud`

- Login to your GCP account and set the projectID
	
	```ini
	gcloud auth login
	gcloud auth application-default login  # For local development
	gcloud config set project $PROJECT_ID
	```

- Set the environment variables

	- Update the relevant `ENV` varaibles in `scripts/set_ENV.sh`

	```ini
	bash scripts/set_ENV.sh
	```