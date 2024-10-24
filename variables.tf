variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  #default     = "us-east-1" # Optional default value
}

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

variable "jdbc_prefix" {
  description = "The JDBC prefix for the database connection"
  type        = string
  default     = "jdbc:postgresql" # Default JDBC prefix
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
variable "db_port" {
  type    = number
  default = 5432
}

variable "db_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
  default     = "csye6225" # Default value, can be overridden
}

variable "db_engine" {
  description = "The database engine for the RDS instance"
  type        = string
  default     = "postgres" # Default database engine
}

variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "16.3" # Default version
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro" # Default instance type
}

variable "allocated_storage" {
  description = "The allocated storage in GB for the RDS instance"
  type        = number
  default     = 20 # Default storage
}
variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting the RDS instance"
  type        = bool
  default     = true # Default value, can be overridden
}

variable "publicly_accessible" {
  description = "Allow public access to the RDS instance"
  type        = bool
  default     = false # Default value, can be overridden
}

variable "multi_az" {
  description = "Enable Multi-AZ for the RDS instance"
  type        = bool
  default     = false # Default value, can be overridden
}

variable "db_parameter_group_name" {
  description = "The name of the RDS parameter group"
  type        = string
  default     = "csye6225-db-parameter-group" # Default value, can be overridden
}

variable "db_parameter_group_family" {
  description = "The family of the RDS parameter group"
  type        = string
  default     = "postgres16" # Default value, can be overridden
}

# Spring Boot-specific environment variables
variable "banner_mode" {
  default = "off"
}

variable "application_name" {
  default = "webapp"
}

variable "show_sql" {
  default = "true"
}

variable "non_contextual_creation" {
  default = "true"
}

variable "hibernate_dialect" {
  default = "org.hibernate.dialect.PostgreSQLDialect"
}

variable "hibernate_ddl_auto" {
  default = "update"
}

variable "volume_type" {
  default = "gp2"
}
variable "delete_on_termination" {
  default = "true"
}
