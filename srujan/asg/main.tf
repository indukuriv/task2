resource "aws_launch_template" "demo-template" {
  name_prefix   = var.name
  image_id      = var.ami_id
  instance_type = var.instance_type
   network_interfaces {
      security_groups = [ var.sg_id ]
      associate_public_ip_address = true
      subnet_id = var.sub_id
    }
  user_data = filebase64("${path.module}/user-data.sh")
}

resource "aws_autoscaling_group" "asg" {
  //availability_zones = [var.availability_zone]
  desired_capacity   = var.desired_capacity
  max_size           = var.max
  min_size           = var.min
  vpc_zone_identifier = [var.sub_id]
  name = "demo_asg"
  launch_template {
    id      = aws_launch_template.demo-template.id
    version = aws_launch_template.demo-template.latest_version
  }
}

resource "aws_autoscaling_attachment" "ex" {
    autoscaling_group_name = aws_autoscaling_group.asg.id
    lb_target_group_arn = var.tg_arn
  
}
