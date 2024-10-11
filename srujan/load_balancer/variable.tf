variable "sg_id" {
  type = string
  default = "aws_security_group"
  description = ""
}

# variable "lb_balancer" {
#   type = string
# }

variable "some_public_subnet" {
  description = "public subnet"
}

variable "public_subnet2" {
  description = "public subnet2"
}

variable "lb_protocol" {
  type = string
  default = "HTTP"
}

variable "lb_port" {
  default = 80
}

variable "instance_port" {
  default = 80
}

variable "instance_protocol" {
  default = "http"
}

variable "vpc_id" {
  type = string
}


#  variable "target_group" {
#    type = string
#  }

variable "target_id" {
  type = string
}