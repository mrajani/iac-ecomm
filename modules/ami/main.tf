data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["amazon"]
  name_regex  = "amzn2-ami-hvm-2.0.*-x86_64-gp2"

  filter {
    name   = "owner-id"
    values = ["137112412989"] # Amazon
  }

  dynamic "filter" {
    for_each = var.filters
    content {
      name   = filter.value["name"]
      values = [filter.value["value"]]
    }
  }
}


