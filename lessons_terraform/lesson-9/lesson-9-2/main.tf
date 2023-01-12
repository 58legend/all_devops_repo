provider "aws" {
  region = "eu-central-1"
}

############################################ security_group 
resource "aws_security_group" "sg_test" {
  name = "SecGroup-lesson9-22-80-443"
  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
  }
  tags = merge(var.additional_tags, { Name = "security_group" }) #Добавляємо таги Name, і з var.aditional_tags

}


############################################ classic load balancer
resource "aws_elb" "load_ballancer" {
  availability_zones = var.availability_zones
  name               = "test-lb-tf"
  internal           = false

  listener {
    instance_port     = 80
    instance_protocol = var.instance_protocol
    lb_port           = 80
    lb_protocol       = var.lb_protocol
  }
  health_check {
    healthy_threshold   = var.health_threshold
    unhealthy_threshold = var.unhealth_threshold
    timeout             = var.timeout_health #Час який чекаємо відповіді, а тоді вважаємо unhealthy
    target              = var.target
    interval            = var.interval_health
  }
  tags = merge(var.additional_tags, { Name = "Load_Ballancer" })
}


resource "aws_launch_configuration" "launch_conf" {
  name_prefix     = "autoscaling_"
  image_id        = var.image_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.sg_test.id]
  key_name        = var.key_name
  user_data       = file("userdata.sh")
 
}

resource "aws_autoscaling_group" "as_group" {
  name                      = "as-group"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_start_size
  health_check_grace_period = var.period
  health_check_type         = "ELB"

  force_delete         = true
  launch_configuration = aws_launch_configuration.launch_conf.name
  availability_zones   = var.availability_zones
  load_balancers       = [aws_elb.load_ballancer.name]


}
resource "aws_autoscaling_policy" "DOWN" {
  name                   = "Policy_DOWN"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 150
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.as_group.name
}
resource "aws_cloudwatch_metric_alarm" "DOWN" {
  alarm_name          = "Cloudwatch_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.as_group.name
  }
  alarm_description = var.alarm_description
  alarm_actions     = [aws_autoscaling_policy.DOWN.arn]
}
################# MY
# resource "aws_autoscaling_policy" "DOWN" { #Зупинення інстанса, якщо навантаження на процесор не велике
#   name                   = "Policy_DOWN"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity" #var.adjustment_type #Що робимо, Дійсні значення: ChangeInCapacity, ExactCapacityі PercentChangeInCapacity
#   cooldown               = 150 #var.autoscalingPolicyCooldown
#   policy_type            = "SimpleScaling" #var.policy_type
#   autoscaling_group_name = aws_autoscaling_group.as_group.name
# }
# resource "aws_cloudwatch_metric_alarm" "DOWN" { #Зупинення інстанса, якщо навантаження на процесор не велике
#   alarm_name          = "Cloudwatch_down"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2" #var.evaluation_periods
#   metric_name         = "CPUUtilization" #var.metric_name
#   namespace           = "AWS/EC2" #var.namespace
#   period              = "60" #var.period
#   statistic           = "Average" #var.statistic
#   threshold           = "30" #var.low_threshold
#   dimensions = {
#     AutoscalingGroupName = aws_autoscaling_group.as_group.name
#   }
#   alarm_description = var.alarm_description
#   alarm_actions     = [aws_autoscaling_policy.DOWN.arn]
# }

# ####################### instance DOWN SASHKA
# resource "aws_autoscaling_policy" "DOWN" {
#   name                   = "Cloudwatch_DOWN"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 150
#   policy_type            = "SimpleScaling"
#   autoscaling_group_name = aws_autoscaling_group.as_group.name
# }
# resource "aws_cloudwatch_metric_alarm" "DOWN" {
#   alarm_name          = "Cloudwatch_DOWN"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "60"
#   statistic           = "Average"
#   threshold           = "30"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.as_group.name
#   }
#   alarm_description = "This metric monitors ec2 cpu utilization"
#   alarm_actions     = [aws_autoscaling_policy.DOWN.arn]
# }


resource "aws_autoscaling_policy" "UP" { #Створення нового інстанса, якщо навантаження на процесор велике
  name                   = "UP"
  scaling_adjustment     = 1
  adjustment_type        = var.adjustment_type
  cooldown               = var.autoscalingPolicyCooldown
  autoscaling_group_name = aws_autoscaling_group.as_group.name
}
# adjustment_type           = "ChangeInCapacity"
# policy_type               = "SimpleScaling"
# metric_name               = "CPUUtilization"
# namespace                 = "AWS/EC2"
# period                    = "60" #second when aws_cloudwatch_metric_alarm check cpu and create or destroy instances
# statistic                 = "Average"
# autoscalingPolicyCooldown = "90" #Seconds of period between creation of instances. Default 150
# alarm_description         = "This metric monitors ec2 cpu utilization"
# instance_protocol         = "http"
# lb_protocol               = "http"
# target                    = "HTTP:80/"
# evaluation_periods        = "2"

resource "aws_cloudwatch_metric_alarm" "UP" { #Створення нового інстанса, якщо навантаження на процесор велике
  alarm_name          = "Cloudwatch_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2" #var.evaluation_periods
  metric_name         = "CPUUtilization" #var.metric_name
  namespace           = "AWS/EC2" #var.namespace
  period              = "60" #var.period
  statistic           = "Average" #var.statistic
  threshold           = "70" #var.high_threshold
  dimensions = {
    AutoscalingGroupName = aws_autoscaling_group.as_group.name
  }
  alarm_description = var.alarm_description
  alarm_actions     = [aws_autoscaling_policy.UP.arn]
}

output "lb_endpoint" {
  value = "http://${aws_elb.load_ballancer.dns_name}"
}
