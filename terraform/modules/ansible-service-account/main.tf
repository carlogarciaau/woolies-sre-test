# This module sets up a service account for use on Ansible playbooks

resource "google_service_account" "ansible_sa" {
  account_id   = "ansible-sa"
  display_name = "Ansible Service Account"
}

resource "google_project_iam_member" "member-role" {
  for_each = toset([
    "roles/compute.instanceAdmin",
    "roles/compute.instanceAdmin.v1",
    "roles/compute.osAdminLogin",
    "roles/iam.serviceAccountUser",
  ])
  role    = each.key
  member  = "serviceAccount:${google_service_account.ansible_sa.email}"
  project = var.project
}

output "sa_email" {
  value = google_service_account.ansible_sa.email
}