variable "ssh_key" {
  default = "bastionhost_sshkey"
}

variable "ami_id" {}
variable "ami_instance_type" {
  default = "t2.micro"
}
variable "azs" {}
variable "public_subnets" {}
variable "public_sg" {}
variable "app_subnets" {}
variable "app_sg" {}

variable "login" {
  default = "ec2-user"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "tags" {}