resource "aws_internet_gateway" "tf-igw" {
  count  = var.tf-count
  tags   = {}
  vpc_id = aws_vpc.VPC[count.index].id
}
