# Створити сервер, на який автоматично встановлюватиметсья nginx, та по ІР буде відкриватись стартова сторінка nginx
#
# lesson 2
#

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "ubuntu" {
  ami = "ami-0e2031728ef69a466"
  instance_type = "t2.micro"
  key_name = "Frankfurt eu-central-1"
  vpc_security_group_ids = [aws_security_group.sg_test.id]
  user_data = "${file("userdata.sh")}"
  tags = {
    Name = "Lesson-2"
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

