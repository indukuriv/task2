variable "availability_zone" {
  type = string
  default = "us-east-2a"
}

variable "cidr_block" {
  default = "10.0.1.0/24"
}

variable "some_custom_vpc" {
  default = "vpc-03e72860710d8cf59"
}

variable "cidr_block1" {
  default = "10.0.0.0/24"
}

variable "availability_zones" {
  default = "us-east-2b"
}