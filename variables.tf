variable "region" {
  description = "Travelstart Infrastructure Region"
  type        = string
  default     = "us-east-2"
}

variable "access_key" {
  description = "Travelstart IAM user access_key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "Travelstart IAM user secret_key"
  type        = string
  sensitive   = true
}
