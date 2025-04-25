variable "name" {
  description = "Base name for ALB"
  type        = string
}
variable "vpc_id" {
  description = "VPC ID to attach ALB"
  type        = string
}
variable "subnet_ids" {
  description = "List of subnet IDs for ALB"
  type        = list(string)
}

variable "frontend_port" {
  type        = number
  description = "Port for frontend TG"
}
variable "backend_port" {
  type        = number
  description = "Port for backend TG"
}
variable "api_path_pattern" {
  type        = string
  description = "Path pattern for backend (/api*)"
}