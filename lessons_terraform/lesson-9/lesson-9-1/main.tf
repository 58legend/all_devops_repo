# наступне завдання
# - налаштувати Auto Scaling group в якій minimum and desired capacity = 1 instance, maximum =3 instances
# - інстанси мають підніматися з встановленим nginx (варіантів як зробити це є мінімум два)
# - перед ними має бути лоадбалансер щоб співпрацював
# --- https://developer.hashicorp.com/terraform/tutorials/aws/aws-asg --- шпаргалка :)


provider "aws" {
  region = var.region

  default_tags {
    tags = {
      hashicorp-learn = "aws-asg"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = "main-vpc"
  cidr = "10.0.0.0/16"

  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# data "aws_ami" "amazon-linux" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn-ami-hvm-*-x86_64-ebs"]
#   }
# }

resource "aws_launch_configuration" "launch_configuration_instance_lesson-9" {
  name_prefix     = "asg-lesson-9"
  key_name        = var.key_name
  image_id        = var.ami_ec2
  instance_type   = "t2.micro"
  user_data       = file("userdata.sh")
  security_groups = [aws_security_group.sg_instance-lesson-9.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg-lesson-9" {
  name                 = "autoscalling group"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2
  launch_configuration = aws_launch_configuration.launch_configuration_instance_lesson-9.name
  vpc_zone_identifier  = module.vpc.public_subnets

  tag {
    key                 = "Name"
    value               = "ASG Instance"
    propagate_at_launch = true # Вмикає розповсюдження тегу до примірників Amazon EC2, запущених через цей ASG
  }
}

resource "aws_lb" "lb_lesson-9" {
  name               = "loadballancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_lb_lesson-9.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_lb_listener" "lissener_lesson-9" {
  load_balancer_arn = aws_lb.lb_lesson-9.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_lesson-9.arn
  }
}

resource "aws_lb_target_group" "lb_tg_lesson-9" {
  name     = "loadballancer-targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}


resource "aws_autoscaling_attachment" "asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.asg-lesson-9.id
  alb_target_group_arn   = aws_lb_target_group.lb_tg_lesson-9.arn
}

resource "aws_security_group" "sg_instance-lesson-9" {
  name = "learn-asg-terramino-instance"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_lb_lesson-9.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_lb_lesson-9.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.sg_lb_lesson-9.id]
  }

  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "sg_lb_lesson-9" {
  name = "sg_loadballancer"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id
}