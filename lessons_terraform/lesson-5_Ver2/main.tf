#
# Підняти по два веб інстанса "Блог", "Адмінка", "бекЕнд", 
# з написом насторінці назва "інстанса + {{ІП інстанса}}"
# Перед ними поставити лоадбалансер який має читати що саме 
# хоче відкрити користувач та перекидати на відпвідні інстанси
#



############################################################## VPS + SUBNETS
provider "aws" {
region = "eu-central-1"
}

resource "aws_default_vpc" "vpc_default" {
  tags = {
    Name = "myvpc"
  }
} 

data "aws_subnet_ids" "selected" {
    vpc_id = aws_default_vpc.vpc_default.id
  }


################################ LOAD BALANCER
resource "aws_alb" "alb" {  
  name            = "lesson-5-alb"  
  subnets         = data.aws_subnet_ids.selected.ids
  security_groups = [aws_security_group.sg_blog.id, aws_security_group.sg_adminka.id, aws_security_group.sg_backend.id]
  internal = false
  ip_address_type = "ipv4"
  load_balancer_type = "application"
}



######################### Target groups 

resource "aws_lb_target_group" "alb_target_blog" {
  name     = "lesson-5-tg-blog"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.vpc_default.id
}


resource "aws_lb_target_group" "alb_target_adminka" {
  name     = "lesson-5-tg-adminka"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.vpc_default.id
}

resource "aws_lb_target_group" "alb_target_backend" {
  name     = "lesson-5-tg-backend"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.vpc_default.id
}


#########################  ATTACH INSTANCES + TARGET GROUP

resource "aws_lb_target_group_attachment" "ec2-attch-blog" {
  count = length(aws_instance.blog)
  target_group_arn = aws_lb_target_group.alb_target_blog.arn
  target_id = aws_instance.blog[count.index].id
}


resource "aws_lb_target_group_attachment" "ec2-attch-adminka" {
  count = length(aws_instance.adminka)
  target_group_arn = aws_lb_target_group.alb_target_adminka.arn
  target_id = aws_instance.adminka[count.index].id
}


resource "aws_lb_target_group_attachment" "ec2-attch-backend" {
  count = length(aws_instance.backend)
  target_group_arn = aws_lb_target_group.alb_target_backend.arn
  target_id = aws_instance.backend[count.index].id
}



output "alb-dns-name" {
  value = aws_alb.alb.dns_name ##Output LoadBallancer-link 
}