#-------- VPC --------#
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = var.tags
}

#-------- AZs --------#
data "aws_availability_zones" "available" {
  state = "available"
}

#-------- Pick Random AZs --------#
resource "random_shuffle" "azs" {
  input        = data.aws_availability_zones.available.names
  result_count = var.subnet_count
}

#-------- Internet Gateway --------#
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, tomap({ "Name" = format("%s-igw", var.tags["Name"]) }))
}

#-------- EIPs for NAT Gateway --------#
resource "aws_eip" "nateip" {
  vpc   = true
  count = var.enable_nat_gateway ? var.subnet_count : 0

  tags = merge(
    var.tags,
    tomap({ "Name" = format("%s-eip-%s", var.tags["Name"], element(var.azs, count.index)) })
  )
}

#-------- NAT Gateways --------#
resource "aws_nat_gateway" "natgw" {
  allocation_id = element(aws_eip.nateip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  count         = var.enable_nat_gateway ? var.subnet_count : 0
  depends_on    = [aws_internet_gateway.main]
  tags = merge(
    var.tags,
    tomap({ "Name" = format("%s-nat-%s", var.tags["Name"], element(var.azs, count.index)) })
  )
}