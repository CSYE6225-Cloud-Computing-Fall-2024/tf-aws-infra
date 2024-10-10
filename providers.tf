variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  #default     = "us-east-1" # Optional default value
}

provider "aws" {
  region = var.region
}
