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

# data "google_iam_policy" "ansible_sa" {
# #   binding {
# #     role = "roles/compute.instanceAdmin"
# #     members = [
# #       "serviceAccount:${google_service_account.ansible_sa.email}",
# #     ]
# #   }

# #   binding {
# #     role = "roles/compute.instanceAdmin.v1"
# #     members = [
# #       "serviceAccount:${google_service_account.ansible_sa.email}",
# #     ]
# #   }

# #   binding {
# #     role = "roles/compute.osAdminLogin"
# #     members = [
# #       "serviceAccount:${google_service_account.ansible_sa.email}",
# #     ]
# #   }

#   binding {
#     role = "roles/iam.serviceAccountUser"
#     members = [
#       "serviceAccount:${google_service_account.ansible_sa.email}",
#     ]
#   }
# }


# resource "google_service_account_iam_policy" "ansible_sa" {
#   service_account_id = google_service_account.ansible_sa.name
#   policy_data        = data.google_iam_policy.ansible_sa.policy_data
# }


# data "google_iam_policy" "instance_admin" {
#   binding {
#     role = "roles/compute.instanceAdmin"
#     members = [
#       "serviceAccount:${google_service_account.ansible_sa.email}",
#     ]
#   }
# }

# resource "google_service_account_iam_policy" "instance_admin" {
#   service_account_id = google_service_account.ansible_sa.name
#   policy_data        = data.google_iam_policy.instance_admin.policy_data
# }