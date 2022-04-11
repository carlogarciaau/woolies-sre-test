variable "region" {
  description = "Region"
  type        = string
  default     = "australia-southeast1"
}

variable "forwarding_rule_port_range" {
  description = "Forwarding rule port range"
  type        = string
  default     = "80"
}

variable "source_ranges" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "target_tags" {
  type    = list(string)
  default = ["web-server"]
}

variable "allowed_ports_for_health_checks" {
  type    = list(string)
  default = ["80"]
}