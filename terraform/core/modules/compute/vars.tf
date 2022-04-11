variable "source_image" {
  type    = string
  default = "debian-cloud/debian-9"
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "subnetwork" {
  type    = string
  default = "subnet-public"
}