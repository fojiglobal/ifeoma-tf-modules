###################### Launch Template ######################

resource "aws_launch_template" "lt" {
  name                                 = "${var.env}-lt"
  image_id                             = var.ami_id
  instance_type                        = var.instance_type
  key_name                             = var.key_pair
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids               = [aws_security_group.private.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-asg-web-server"
    }
  }

  user_data = var.user_data
}

###################### ASG ######################

resource "aws_autoscaling_group" "asg" {
  name                = "${var.env}-asg"
  vpc_zone_identifier = [for subnet in aws_subnet.private : subnet.id]
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  target_group_arns   = [aws_lb_target_group.tg.arn]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "name"
    value               = "${var.env}-asg-web-server"
    propagate_at_launch = true
  }
}