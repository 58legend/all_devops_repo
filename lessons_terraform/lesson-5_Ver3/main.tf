
# Підняти по два веб інстанса "Блог", "Адмінка", "бекЕнд", 
# з написом насторінці назва "інстанса + {{ІП інстанса}}"
# Перед ними поставити лоадбалансер який має читати що саме
# хоче відкрити користувач та перекидати на відпвідні інстанси


/*
resource "aws_lb" "test" {
  name               = "app-load-bal"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}


resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.group.arn}"
    type             = "forward"
  }
}



*/
