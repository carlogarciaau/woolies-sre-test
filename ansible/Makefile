.PHONY : inventory apply

SERVICE = webserver
PROJECT=$$(gcloud config get-value project)

inventory:
	@echo "Creating inventory file"
	@echo "[nginx]" > inventory
	@gcloud compute instances list --project $(PROJECT) --filter 'name~"$(WEBSERVER)-*"' \
	 | awk '{print $$5}' | grep -E '[0-9\.]+' >> inventory

upload:
	@echo "Uploading configs to gs://wooliesx-sre-exam-nginx-conf"
	@gsutil cp index.html gs://wooliesx-sre-exam-nginx-conf

apply: inventory upload
	@export ANSIBLE_HOST_KEY_CHECKING=False
	@echo "Running ansible playbook"
	@ansible-playbook -i inventory nginx.yml --tags "config" --ssh-common-args='-o StrictHostKeyChecking=no'

setup-ssh-keys:
	gcloud compute project-info add-metadata \
		--metadata enable-oslogin=TRUE 

	gcloud iam service-accounts keys create \
    	.gcp/gcp-key-ansible-sa.json \
    	--iam-account=ansible-sa@$(PROJECT).iam.gserviceaccount.com
	
	ssh-keygen -b 2048 -t rsa -f ssh-key-ansible-sa -q -N ""
	
	gcloud auth activate-service-account \
    	--key-file=.gcp/gcp-key-ansible-sa.json 
	
	gcloud compute os-login ssh-keys add \
    	--key-file=ssh-key-ansible-sa.pub

	@echo "\n\nFinished setting up ssh keys. Don't forget to switch back to your GCP account. "
	@echo "e.g. gcloud config set account your@gmail.com\n\n"
	@echo "Update the ansible_ssh_user variable in the nginx.yml playbook with this ID:"
	@gcloud iam service-accounts describe \
    	ansible-sa@$(PROJECT).iam.gserviceaccount.com \
    	--format='value(uniqueId)'