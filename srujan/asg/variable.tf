variable "name" {
  type = string
}
variable "ami_id" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "availability_zone" {
  default = "us-east-2a"
}
variable "desired_capacity" {
  type = string
}
variable "max" {
  type = string
}
variable "min" {
  type = string
}
variable "tg_arn" {
  type=string
}
variable "sg_id" {
  type=string
}
variable "sub_id" {
  type=string
}
