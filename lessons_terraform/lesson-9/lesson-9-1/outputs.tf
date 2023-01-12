output "lb_endpoint" {
  value = "https://${aws_lb.lb_lesson-9.dns_name}"
}

output "application_endpoint" {
  value = "https://${aws_lb.lb_lesson-9.dns_name}/index.php"
}

output "asg_name" {
  value = aws_autoscaling_group.asg-lesson-9.name
}