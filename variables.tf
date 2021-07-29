variable "profile" {
  default = "default"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc" {
  default = "KoffeLuv"
}

variable "name" {
  description = "Name of the VPC"
  default     = "KoffeLuv"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "creds_path" {
  default = "~/.aws/credentials"
}

variable "subnet_count" {
  description = "Number of Subnets"
  default     = "3"
}

variable "use_az_count" {
  description = "Number of AZs to use"
  default     = "3"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default = {
    Name        = "KoffeLuv"
    Environment = "Dev"
  }
}

variable "enable_nat_gateway" {
  description = "Enable or Disable NAT gateway"
  default     = "true"
}
