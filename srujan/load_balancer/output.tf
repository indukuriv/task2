output "elb" {
    value = aws_lb.balancer.id
}

output "ec2_instance" {
    value = aws_lb_target_group.ec2_instance.arn
}

output "load" {
  value = aws_lb.balancer.arn
}
