variable "project_id" {
  description = "The ID of the GCP project."
  
  type        = string

}

variable "europe_region" {
  description = "The European region for HQ."
  default     = "europe-west1"
}

variable "america_region_1" {
  description = "The first Americas region."
  default     = "us-east1"
}

variable "america_region_2" {
  description = "The second Americas region."
  default     = "us-west1"
}

variable "asia_region" {
  description = "The Asia-Pacific region."
  default     = "asia-east1"
}