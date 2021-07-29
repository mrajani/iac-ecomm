output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ami_id" {
  value = module.ami.amazon_ami
}

output "bastionhost_sshkey" {
  value = module.compute.bastionhost_sshkey
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "app_subnets" {
  value = module.vpc.app_subnets
}

output "public_ip" {
  value = module.compute.public_ip
}

output "app_id" {
  value = module.compute.app_ip
}