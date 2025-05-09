variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}
variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets (one per AZ)"
  type        = list(string)
}
