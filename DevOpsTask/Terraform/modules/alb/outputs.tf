output "alb_arn" {
  value = aws_lb.this.arn
}
output "alb_dns_name" {
  value = aws_lb.this.dns_name
}
output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "frontend_tg_arn" {
  value = aws_lb_target_group.frontend.arn
}
output "backend_tg_arn" {
  value = aws_lb_target_group.backend.arn
}