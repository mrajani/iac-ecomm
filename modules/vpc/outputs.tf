output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "app_subnets" {
  value = aws_subnet.private[*].id
}

output "public_sg" {
  value = aws_security_group.public.id
}

output "app_sg" {
  value = aws_security_group.app.id
}

