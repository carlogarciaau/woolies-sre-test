variable "project" {
  description = "project id"
  type        = string
  default     = "cg-wooliesx-sre-exam-project"
}

variable "region" {
  description = "region"
  type        = string
  default     = "australia-southeast1"
}

variable "backend_bucket" {
  description = "backend bucket for tf state"
  type        = string
  default     = "wooliesx-sre-exam-terraform-states"
}

variable "nginx_conf_bucket" {
  description = "backend bucket for nginx conf"
  type        = string
  default     = "wooliesx-sre-exam-nginx-conf"
}
