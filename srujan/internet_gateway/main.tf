resource "aws_internet_gateway" "igw" {
  vpc_id = var.some_custom_vpc
  tags = {
    Name = "internet1"
  }
}