locals {
  ssh_config = pathexpand(lower(format("~/.ssh/ssh_%s_config", var.tags["Name"])))
}

resource "local_file" "ssh_config" {
  filename        = local.ssh_config
  file_permission = "0644"
  content = templatefile("${path.module}/templates/ssh_config.tpl",
    {
      ssh_config      = local.ssh_config
      ssh_user        = "ec2-user"
      bastion_ssh_key = var.ssh_key
      app_ip          = tolist(aws_instance.app[*].private_ip)
      bastion_ip      = aws_instance.public[*].public_ip
  })

}
