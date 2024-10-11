output "subnet_id" {
  description = "subnet id"
  value       = aws_subnet.some_public_subnet.id
}

output "subnet_id2" {
  value = aws_subnet.public_subnet2.id
}