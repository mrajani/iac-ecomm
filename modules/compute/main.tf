# data "terraform_remote_state" "compute" {
#   backend = "local"

#   config = {
#     path = "${path.module}/../../terraform.tfstate"
#   }
# }

#-------- Gen Key Pair --------#
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.ssh_key
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "aws_instance" "public" {
  count                  = length(var.public_subnets)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = element(var.public_subnets, count.index)
  vpc_security_group_ids = [var.public_sg]
  key_name               = var.ssh_key
  source_dest_check      = false

  tags = merge(
    var.tags,
    tomap({ "Name" = format("%s-Public-%s", var.tags["Name"], count.index) })
  )

  connection {
    user        = var.login
    private_key = tls_private_key.tfadmin.private_key_pem
    host        = self.public_ip
  }
}

resource "aws_instance" "app" {
  count                  = length(var.app_subnets)
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = element(var.app_subnets, count.index)
  vpc_security_group_ids = [var.app_sg]
  key_name               = var.ssh_key
  source_dest_check      = false

  tags = merge(
    var.tags,
    tomap({ "Name" = format("%s-App-%s", var.tags["Name"], count.index) })
  )

  connection {
    user        = var.login
    private_key = tls_private_key.tfadmin.private_key_pem
    host        = self.public_ip
  }
}

resource "local_file" "private_pem" {
  content         = tls_private_key.key_pair.private_key_pem
  filename        = pathexpand("~/.ssh/${var.ssh_key}.pem")
  file_permission = "0600"
}

resource "local_file" "public_openssh" {
  content         = tls_private_key.key_pair.public_key_openssh
  filename        = pathexpand("~/.ssh/${var.ssh_key}.pub")
  file_permission = "0644"
}
