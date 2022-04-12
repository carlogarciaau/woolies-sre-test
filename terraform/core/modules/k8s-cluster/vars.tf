variable "project" {
  description = "project id"
  type        = string
  default     = "cg-wooliesx-devops-exam"
}

variable "region" {
  description = "region"
  type        = string
  default     = "australia-southeast1"
}

variable "vpc_name" {
  description = "Name of the vpc network"
  type        = string
  default     = "vpc"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "subnet-private"
}