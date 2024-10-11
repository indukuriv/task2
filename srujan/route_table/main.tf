resource "aws_route_table" "route" {
  vpc_id = var.some_custom_vpc

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw
  }
  tags = {
    Name = "route-table"
  }
}

resource "aws_route_table_association" "route1" {
  subnet_id = var.subnet1_id
  route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "route2" {
  subnet_id = var.subnet2_id
  route_table_id = aws_route_table.route.id
}