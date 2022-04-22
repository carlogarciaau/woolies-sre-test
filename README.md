# WX-SRE-Test

## Summary
Deployment of NGINX servers on GCE and K8s using Terraform as well as some Ansible tasks. This is all done in GCP.

## Pre-requisites
1. A GCP project with billing enabled
2. gcloud CLI (https://cloud.google.com/sdk/docs/install)
3. Configure gcloud `gcloud init;` `gcloud auth application-default login`
4. Terraform CLI (using v1.0.7 as of this writing)
5. Ansible (www.ansible.com); If on MAC -> `brew install ansible`
6. kubectl `gcloud components install kubectl`

## GCE Deployment Steps:
1. `cd terraform;` Update vars.tf with your GCP project id and region
2. `terraform init / fmt --recursive / validate / plan / apply`
3. This provisions the VPC, subnets, HTTP load balancer, instance group, K8s cluster, and the rest of the infrastructure. 

## K8s App Deployment
1. Setup k8s - `gcloud container clusters get-credentials <YOUR_PROJECT_ID>-gke --region <YOUR_REGION> --project <YOUR_PROJECT_ID>`
2. Example: `gcloud container clusters get-credentials my-project-gke --region australia-southeast1 --project wx-exam`
3. `cd k8s/overlay/dev`
4. Test with `kubectl apply -k . --dry-run=client`
5. Apply with `kubectl apply -k .` 
6. Note: overlay directories simulate a dev or prod environment. Dev will not deploy an HPA while Prod does along with increased resources and a rollingupdate strategy.

## Public endpoints
1. There should now be 2 public HTTP endpoints in GCE and K8S. Use `gcloud compute forwarding-rules list` to retrieve these. 

## Ansible
1. Make sure you are currently in the right project before proceeding. `gcloud config get-value project`. 
2. `cd ansible;` `make setup-ssh-keys;` This sets up the service account keys and ssh keys. 
3. Follow instruction from prompt and update `nginx.yml` playbook with the service account id.
4. Example:  `ansible_ssh_user: 'sa_1324984113574'`
5. `make test` to perform a dry-run
6. `make apply` will create an inventory of running instances and update the NGINX servers running on each.
7. Make sure to switch back from the ansible service account to your account. `gcloud config set account your@gmail.com`
 

## Activity Notes:
- Two subnets were created (public/private). Subnets in GCP are a bit vague with regards to this, as external IP addresses are assigned at resource level. 
- A Cloud NAT Gateway was provisioned to allow outbound connectivity. In practice, further firewall rules will be created to only keep the necessary open ports.
- Scaling on GCE was done using a regional instance group manager and regional autoscaler. On K8s, an HPA was included. 
- Ansible connection was accomplished by creating a service account with keys and also generating ssh key pairs.

### What needs to be set up for ansible to be able to control windows machines?
1. PowerShell 3.0 or newer and at least .NET 4.0 to be installed on the Windows host.
2. WinRM listener should be created and activated


## References:
- https://registry.terraform.io/providers/hashicorp/google/latest/docs
- https://alex.dzyoba.com/blog/gcp-ansible-service-account/