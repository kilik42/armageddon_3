terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.27.0"
    }
  }
}

provider "google" {
#   project = "training-416401"
  
 credentials = "training-416401-151621fcb8a1.json"
  project = var.project_id
  region  = var.europe_region
}
