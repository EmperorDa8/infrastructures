# AWS Variables
variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "aws_vpc_cidr" {
  description = "CIDR for AWS VPC"
  default     = "10.0.0.0/16"
}

variable "aws_subnet_cidr" {
  description = "CIDR for AWS subnet"
  default     = "10.0.1.0/24"
}

variable "aws_instance_type" {
  description = "AWS instance type"
  default     = "t3.large"
}

variable "aws_ad_instance_name" {
  description = "Name for AWS AD instance"
  default     = "ad-server"
}

variable "aws_db_instance_name" {
  description = "Name for AWS DB instance"
  default     = "db-server"
}

variable "aws_key_name" {
  description = "Name of AWS key pair"
}

# GCP Variables
variable "gcp_project_id" {
  description = "GCP project ID"
}

variable "gcp_region" {
  description = "GCP region"
  default     = "us-central1"
}

variable "gcp_network_name" {
  description = "Name for GCP network"
  default     = "ad-db-network"
}

variable "gcp_subnet_cidr" {
  description = "CIDR for GCP subnet"
  default     = "10.0.0.0/24"
}

variable "gcp_machine_type" {
  description = "GCP machine type"
  default     = "n2-standard-2"
}

variable "gcp_ad_instance_name" {
  description = "Name for GCP AD instance"
  default     = "ad-server"
}

variable "gcp_db_instance_name" {
  description = "Name for GCP DB instance"
  default     = "db-server"
}