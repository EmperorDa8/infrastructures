# Provider configurations
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# AWS Resources
module "aws_infrastructure" {
  source = "./modules/aws"

  vpc_cidr            = var.aws_vpc_cidr
  subnet_cidr         = var.aws_subnet_cidr
  instance_type       = var.aws_instance_type
  ad_instance_name    = var.aws_ad_instance_name
  db_instance_name    = var.aws_db_instance_name
  key_name           = var.aws_key_name
}

# GCP Resources
module "gcp_infrastructure" {
  source = "./modules/gcp"

  network_name        = var.gcp_network_name
  subnet_cidr         = var.gcp_subnet_cidr
  machine_type        = var.gcp_machine_type
  ad_instance_name    = var.gcp_ad_instance_name
  db_instance_name    = var.gcp_db_instance_name
}