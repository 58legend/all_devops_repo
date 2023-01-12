provider "aws" {
}
data "aws_vpc" "selected" {
  default = true
}
resource "aws_security_group" "for_instances" {
    name             = var.name
  dynamic "ingress" {
    for_each         = var.allow_ports
  content {
    from_port        = ingress.value
    to_port          = ingress.value
    protocol         = "tcp"
    cidr_blocks      = var.cidr_blocks
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.cidr_blocks
  }
  tags = {
    Owner = var.Owner
  }
}
data "aws_ami" "linux" {
  owners = var.owners
  most_recent = true
  filter {
    name   = "name"
    values = var.values
  }
}
resource "aws_launch_configuration" "as_conf" {
  name_prefix        = var.name_prefix
  image_id           = data.aws_ami.linux.id
  instance_type      = var.instance_type
  security_groups    = [aws_security_group.for_instances.id]
  key_name           = var.key_name
  user_data          = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "bar" {
  name                      = "foobar3-terraform-test"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "ELB"
  desired_capacity          = 3
  force_delete              = true
  launch_configuration      = aws_launch_configuration.as_conf.name
  availability_zones        = var.availability_zones
  load_balancers            = [aws_elb.bar.name]  

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_policy" "DOWN" {
  name                   = "DOWN"
  scaling_adjustment     = -1
  adjustment_type        = var.adjustment_type
  cooldown               = 150
  policy_type            = var.policy_type
  autoscaling_group_name = aws_autoscaling_group.bar.name
}
resource "aws_cloudwatch_metric_alarm" "DOWN" {
  alarm_name          = "Cloudwatch_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  dimensions = {
    AutoscalingGroupName = aws_autoscaling_group.bar.name
  }
  alarm_description = var.alarm_description
  alarm_actions     = [aws_autoscaling_policy.DOWN.arn]
}
resource "aws_autoscaling_policy" "UP" {
  name                   = "UP"
  scaling_adjustment     = 1
  adjustment_type        = var.adjustment_type
  cooldown               = 150
  autoscaling_group_name = aws_autoscaling_group.bar.name
}
resource "aws_cloudwatch_metric_alarm" "UP" {
  alarm_name          = "Cloudwatch_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  dimensions = {
    AutoscalingGroupName = aws_autoscaling_group.bar.name
  }
  alarm_description = var.alarm_description
  alarm_actions     = [aws_autoscaling_policy.UP.arn]
}
resource "aws_elb" "bar" {
  name               = "foobar-terraform-elb"
  availability_zones = var.availability_zones
  listener {
    instance_port     = 80
    instance_protocol = var.instance_protocol
    lb_port           = 80
    lb_protocol       = var.lb_protocol
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = var.target
    interval            = 30
  }
  tags = {
    Name = var.Name
  }
}