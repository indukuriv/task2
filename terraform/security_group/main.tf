resource "aws_security_group" "securitygroup" {
  # ... other configuration ...
  name = var.sg
  vpc_id = var.some_custom_vpc
ingress{
    from_port        = 22
    to_port          = 22
    protocol         = "Tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}