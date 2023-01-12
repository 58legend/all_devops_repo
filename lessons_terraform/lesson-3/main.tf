/*
Підняти 
- два інстанса з відкритим 80 портом та встановленим nginx
- аплікейшен Лоадбалансер який буде дивитись на ці два інстанси
- доступ до сайтів має бути лише через лоадбалансер, доступ по ІР інстанса не має бути
*/
provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "ubuntu" {
  ami = "ami-0e2031728ef69a466"
  instance_type = "t2.micro"
  key_name = "Frankfurt eu-central-1"
  count = 2 #How many instance we need
  vpc_security_group_ids = [aws_security_group.sg_test.id]
  user_data = "${file("userdata.sh")}" #Please write user-data in /userdata.sh
  tags = {
    Name = "Lesson-3"
  }
}
resource "aws_security_group" "sg_test" {
  name = "sec-grp-22-80"
  description = "Allow HTTP and SSH traffic via Terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#-------------------------------------------------
#Створюємо subnet
#
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Less-3-subnet"
  }
}

#-------------------------------------------------
#Створюємо target group
#
resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.1.0/24"
}

#-------------------------------------------------
#Створюємо application load balancer
#
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_test.id]
  subnets            = [aws_subnet.main.id]

  enable_deletion_protection = true
/*
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }*/

  tags = {
    Environment = "production"
  }
}

