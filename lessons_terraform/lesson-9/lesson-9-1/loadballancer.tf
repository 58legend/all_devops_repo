# resource "aws_lb_target_group" "tg-lesson-9" {
#   name     = "learn-asg-hashicups"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = module.vpc.vpc_id
# }

# resource "aws_lb" "terramino" {
#   name               = "learn-asg-terramino-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.sg_lesson_9.id]
#   subnets            = module.vpc.public_subnets
# }


# resource "aws_lb_listener" "terramino" {
#   load_balancer_arn = aws_lb.terramino.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.terramino.arn
#   }
# }