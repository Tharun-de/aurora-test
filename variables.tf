variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr1" {
  description = "CIDR for the first subnet"
  default     = "10.0.1.0/24"
}

variable "subnet_cidr2" {
  description = "CIDR for the second subnet"
  default     = "10.0.2.0/24"
}

variable "db_name" {
  description = "Database name"
  default     = "mydatabase"
}

variable "db_user" {
  description = "Database master username"
  default     = "adminuser"
}

variable "db_password" {
  description = "Database master password"
  default     = "securepassword123!"
  sensitive   = true
}
