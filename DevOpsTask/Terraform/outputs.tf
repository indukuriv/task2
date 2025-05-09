output "alb_dns" {
  description = "Public DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "frontend_url" {
  description = "Frontend Application URL"
  value       = "http://${module.alb.alb_dns_name}"
}

output "backend_api_url" {
  description = "Backend API base URL"
  value       = "http://${module.alb.alb_dns_name}/api"
}
