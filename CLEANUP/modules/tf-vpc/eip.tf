resource "aws_eip" "tf-eip" {
  count            = var.tf-count
  public_ipv4_pool = "amazon"
  vpc              = true
  tags = {
    "Name" = "TF-EIP"
  }

  timeouts {}
}
