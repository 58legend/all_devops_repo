provider "aws" {
  region = "eu-central-1"
}

#Підтягуємо ВПС та сабнет дефолтні
data "aws_vpc" "default" {
  default = "true"
}

#data "aws_subnet_ids" "subnet" {
#  vpc_id = data.aws_vpc.default.id
#}

resource "aws_subnet" "subnet_private1" {
vpc_id = data.aws_vpc.default.id
  availability_zone = "eu-central-1a"
 cidr_block      = "172.31.58.0/24"
}

data "aws_subnet_ids" "subnet_private1" {
  vpc_id = data.aws_vpc.default.id
}


resource "aws_subnet" "subnet_private2" {
  vpc_id = data.aws_vpc.default.id
  availability_zone = "eu-central-1b"
  cidr_block      = "172.31.59.0/24"
}


resource "aws_instance" "instance_lesson_3" {
  ami = "ami-05ff5eaef6149df49"
  instance_type = "t2.micro"
  user_data = "${file("bash.sh")}"
  key_name = "Frankfurt eu-central-1"
  vpc_security_group_ids = [aws_security_group.sec_my_web.id]
  subnet_id                   = aws_subnet.subnet_private1.id
  count = 3
  tags = {
    Name = "lesson-3-[instance#${count.index}]"
  }
}

#
# Створюємо security_group для інстансів
#
resource "aws_security_group" "sec_my_web" {
  name        = "sec_my_web"
  description = "security-group-lesson-3 22/80/443"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
   # cidr_blocks      = [data.aws_vpc.default.cidr_block]
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-group-instance-lesson3"
  }
}


#
# Створюємо security_group для load ballancer
#
resource "aws_security_group" "sec_my_web_lb" {
  name        = "sec_my_web_lb"
  description = "security-group-lb-lesson-3 80"

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "security-group-lesson-3"
  }
}




#
# Створюємо таргет групу
#
resource "aws_lb_target_group" "alb_tg" {
    name     = "less3-targetgroup"
    port     = 80
    protocol = "HTTP"
    vpc_id   = data.aws_vpc.default.id
}

#
# Створюємо Load Ballancer
#

resource "aws_lb" "alb" {
    name               = "less3-loadballancer"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.sec_my_web_lb.id]
   # subnets            = [data.aws_subnet_ids.subnet.ids]
    subnets            = [aws_subnet.subnet_private1.id, aws_subnet.subnet_private2.id]
     
      tags = {
    name = "less3-a-loadballancer"
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.arn
    type = "forward"
  }
}

resource "aws_lb_target_group_attachment" "ec2-attch" {
  count = length(aws_instance.instance_lesson_3)
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id = aws_instance.instance_lesson_3[count.index].id
}

output "elb-dns-name" {
  value = aws_lb.alb.dns_name
}

