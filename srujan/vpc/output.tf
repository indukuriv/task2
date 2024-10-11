output "ec2_vpc_id" {
  description = "ec2"
  value = aws_vpc.some_custom_vpc.id

}