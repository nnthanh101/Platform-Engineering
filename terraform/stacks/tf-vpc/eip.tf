resource "aws_eip" "tf-eip" {
  public_ipv4_pool = "amazon"
  vpc              = true
  tags = {
    "Name" = "TF-EIP"
  }

  timeouts {}
}
