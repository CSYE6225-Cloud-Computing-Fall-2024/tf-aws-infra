variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1d", "us-east-1e", "us-east-1f"]
}

variable "ami_id" {
  description = "The ID of the custom AMI to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro" # Default instance type if none is provided
}

variable "application_port" {
  description = "Port on which the application runs"
  type        = number
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 25 # Default size is 25GB if none is provided
}

variable "db_user" {
  default = "postgres"
}

variable "db_pass" {
  default = "Northeastern2024"
}

variable "db_name" {
  default = "webapp"
}
