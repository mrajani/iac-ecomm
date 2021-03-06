variable "prefix" {
  description = "Some random message to include in tags"
  default     = "iono"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
  default     = ""
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "azs" {
  description = "A list of Availability zones in the region"
  default     = []
}

variable "enable_dns_hostnames" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "should be true if you want to use private DNS within the VPC"
  default     = true
}

variable "enable_nat_gateway" {
  description = "Set to true to provision NAT Gateways for each of your private networks"
  default     = "true"
}

variable "enable_dhcp_options" {
  description = "Set to true to provide DHCP within VPC"
  default     = "false"
}

variable "map_public_ip_on_launch" {
  description = "should be false if you do not want to auto-assign public IP on launch"
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "subnet_count" {
  default = 3
}
