variable "vpc_name" {
  description = "Name of the vpc network"
  type        = string
  default     = "vpc"
}

variable "vpc_description" {
  description = "Describes the VPC's purpose"
  type        = string
  default     = "Default VPC"
}

variable "public_subnet_name" {
  description = "Name for the publicsubnet"
  type        = string
  default     = "subnet-public"
}

variable "public_subnet_description" {
  description = "Description for the public subnet"
  type        = string
  default     = "public subnet"
}

variable "public_subnet_region" {
  description = "Region for the public subnet"
  type        = string
}

variable "private_subnet_name" {
  description = "Name for the private subnet"
  type        = string
  default     = "subnet-private"
}

variable "private_subnet_description" {
  description = "Description for the private subnet"
  type        = string
  default     = "private subnet"
}

variable "private_subnet_region" {
  description = "Region for the private subnet"
  type        = string
}

variable "cidr_public" {
  description = "CIDR range for public subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "cidr_private" {
  description = "CIDR range for private subnet"
  type        = string
  default     = "10.0.1.0/24"
}

