resource "aws_vpc" "some_custom_vpc" {
    cidr_block = var.cidr_block
  tags = {
    Name = "MY VPC"
  }
}
