#-------- Setup Public Subnet, Route Table, Association with igw-  --------#
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = element(var.azs, count.index)
  count             = length(var.azs)
  tags = merge(
    var.tags,
    tomap({ "Name" = format("%s-rt-public-%s", var.tags["Name"], element(var.azs, count.index)) })
  )

  map_public_ip_on_launch = var.map_public_ip_on_launch
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(
    var.tags,
    tomap({ "Name" = format("%s-rt-public", var.tags["Name"]) })
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

#-------- Setup Private Subnet, Route Table, Association with nat-gw-  --------#
resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 1 * length(var.azs))
  availability_zone = element(var.azs, count.index)


  tags = merge(
    var.tags,
    tomap({ "Name" = format("%s-private-%s", var.tags["Name"], element(var.azs, count.index)) })
  )
}

resource "aws_route_table" "internal" {
  count  = var.enable_nat_gateway ? var.subnet_count : 0
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    tomap({ "Name" = format("%s-rt-internal-%s", var.tags["Name"], element(var.azs, count.index)) })
  )
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw[count.index].id
  }
}

resource "aws_route_table_association" "private" {
  count          = var.enable_nat_gateway ? var.subnet_count : 0
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.internal.*.id, count.index)
}

#-------- Setup DB Subnet, Route Table, Association with nat-gw-  --------#
resource "aws_subnet" "db" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 2 * length(var.azs))
  availability_zone = element(var.azs, count.index)


  tags = merge(
    var.tags,
    tomap({ "Name" = format("%s-db-%s", var.tags["Name"], element(var.azs, count.index)) })
  )
}

resource "aws_route_table_association" "db" {
  count          = var.enable_nat_gateway ? var.subnet_count : 0
  subnet_id      = element(aws_subnet.db.*.id, count.index)
  route_table_id = element(aws_route_table.internal.*.id, count.index)
}


// Define Security groups
resource "aws_security_group" "app" {
  name        = "${var.tags["Name"]}-sg-app"
  description = "Default security group that allows inbound and outbound traffic from all instances in the Public SG"
  vpc_id      = aws_vpc.main.id
  tags = merge(
    var.tags,
  tomap({ "Name" = format("%s-sg-app", var.tags["Name"]) }))

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.public.id}"]
  }
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
}

resource "aws_security_group" "public" {
  name        = "${var.tags["Name"]}-public"
  description = "Security group for Public Subnet that allows traffic from internet"
  vpc_id      = aws_vpc.main.id
  tags        = merge(var.tags, tomap({ "Name" = format("%s-sg-public", var.tags["Name"]) }))

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
