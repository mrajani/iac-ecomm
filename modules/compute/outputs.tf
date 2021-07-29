output "bastionhost_sshkey" {
  value = aws_key_pair.ssh_key.id
}

output "public_ip" {
  value = aws_instance.public[*].public_ip
}

output "app_ip" {
  value = aws_instance.app[*].private_ip
}