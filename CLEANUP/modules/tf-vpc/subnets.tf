resource "aws_subnet" "tf-public-subnet" {
  count                           = var.tf-count
  assign_ipv6_address_on_creation = false
  availability_zone               = "ap-southeast-1a"
  cidr_block                      = format("172.30.0.%s/27", count.index)
  map_public_ip_on_launch         = false
  tags = {
    "Name" = format("Public-Subnet 172.30.0.%s/27", count.index)
  }
  vpc_id = aws_vpc.VPC[count.index].id

  timeouts {}
}

resource "aws_subnet" "tf-private-subnet" {
  count                           = var.tf-count
  assign_ipv6_address_on_creation = false
  availability_zone               = "ap-southeast-1a"
  cidr_block                      = "172.30.0.128/27"
  map_public_ip_on_launch         = false
  tags = {
    "Name" = "Private-Subnet 172.30.0.128/27"
  }
  vpc_id = aws_vpc.VPC[count.index].id

  timeouts {}
}
