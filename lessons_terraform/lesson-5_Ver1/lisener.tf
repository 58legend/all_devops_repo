######################### Liseners 

resource "aws_alb_listener" "alb_listener_blog" {  
#  depends_on = [aws_alb_target_group.alb_target_blog]
  load_balancer_arn = aws_alb.alb.arn  
  port              = "80"  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = aws_lb_target_group.alb_target_blog.arn
    type             = "forward"  
  }
}



resource "aws_alb_listener" "alb_listener_adminka" {  
#  depends_on = [aws_alb_target_group.alb_target_adminka]
  load_balancer_arn = aws_alb.alb.arn  
  port              = "58581"  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = aws_lb_target_group.alb_target_adminka.arn
    type             = "forward"  
  }
}


resource "aws_alb_listener" "alb_listener_backend" {  
#  depends_on = [aws_alb_target_group.alb_target_backend]
  load_balancer_arn = aws_alb.alb.arn  
  port              = "58582"  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = aws_lb_target_group.alb_target_backend.arn
    type             = "forward"  
  }
}









############## RULES (Пробував створювати по домену)
/*
resource "aws_lb_listener_rule" "adminka" {
  listener_arn = aws_alb_listener.alb_listener_blog.arn
  priority     = 100
    
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_adminka.arn
  }
  condition {
    path-pattern {
    values = ["/adminka/*"]
    }
  }
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_alb_listener.alb_listener_blog.arn
  priority     = 99
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_backend.arn
  }
  condition {
    path_pattern {
    values = ["/backend/*"]
    }
  }
}
*/