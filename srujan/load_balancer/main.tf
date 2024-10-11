resource "aws_lb" "balancer" {
  name = "load-balancer"
  load_balancer_type = "application"
  //availability_zone = var.availability_zones
  security_groups = [var.sg_id]
  subnets = [var.some_public_subnet, var.public_subnet2]
}
# resource "aws_lb_listener" "front_end" {
#     lb_port = var.lb_port
#     lb_protocol = var.lb_protocol
#     instance_port = var.instance_port
#     instance_protocol = var.instance_protocol
# }

resource "aws_lb_listener" "lb_list" {
  load_balancer_arn = aws_lb.balancer.arn
  port              = var.lb_port
  protocol          = var.lb_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_instance.arn
  }
}

resource "aws_lb_target_group" "ec2_instance" {
  name        = "demo"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}

# resource "aws_lb_target_group_attachment" "attach-demo" {
#   target_group_arn = aws_lb_target_group.ec2_instance.arn
#   target_id        = var.target_id
#   port             = 80
# }

