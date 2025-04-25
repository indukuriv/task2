variable "name" {
  description = "Base name for ECS service & task"
  type        = string
}
variable "cluster_id" {
  description = "ECS cluster ID"
  type        = string
}
variable "container_image" {
  description = "Full image URI (ECR) for the container"
  type        = string
}
variable "container_port" {
  description = "Port the container listens on"
  type        = number
}
variable "desired_count" {
  description = "Number of tasks"
  type        = number
  default     = 1
}
variable "cpu" {
  description = "Task CPU units"
  type        = number
  default     = 256
}
variable "memory" {
  description = "Task memory (MB)"
  type        = number
  default     = 512
}
variable "subnet_ids" {
  description = "List of subnet IDs for task networking"
  type        = list(string)
}
variable "security_group_ids" {
  description = "List of security group IDs for tasks"
  type        = list(string)
}
variable "assign_public_ip" {
  description = "Whether to assign public IP to ENI"
  type        = bool
  default     = false
}

# variable "vpc_id" {
#   #description = "Whether to assign public IP to ENI"
#   type        = string
# }

variable "target_group_arn" {
  #description = "Whether to assign public IP to ENI"
  type        = string
}