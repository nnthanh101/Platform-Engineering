resource "aws_subnet" "tf-private-subnet" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "ap-southeast-1"
  cidr_block                      = "10.1.4.0/24"
  map_public_ip_on_launch         = false
  tags = {
    "Name" = "TF-Private-Subnet"
  }
  vpc_id = aws_vpc.tf-vpc.id

  timeouts {}
}

resource "aws_subnet" "tf-public-subnet" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "ap-southeast-1"
  cidr_block                      = "10.1.1.0/24"
  map_public_ip_on_launch         = false
  tags = {
    "Name" = "TF-Public-Subnet"
  }
  vpc_id = aws_vpc.tf-vpc.id

  timeouts {}
}
