resource "aws_security_group" "tf-sg" {
  count       = var.tf-count
  description = "Security Group - Inbound"
  vpc_id      = aws_vpc.VPC[count.index].id
}
