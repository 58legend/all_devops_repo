resource "aws_instance" "blog" {
  ami = "ami-0e2031728ef69a466" #Amazon linux
  instance_type = var.instance_type
  key_name = "Frankfurt eu-central-1"
  count = 2 #How many instance we need
  vpc_security_group_ids = [aws_security_group.sg_blog.id]
  user_data = "${file("userdata.sh")}" #Please write user-data in /userdata.sh
  tags = {
    Name = "Lesson-5-blog"
  }
}
resource "aws_security_group" "sg_blog" {
  name = "BLOG"
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


##########################################################


resource "aws_instance" "adminka" {
  ami = "ami-0e2031728ef69a466"
  instance_type = var.instance_type
  key_name = "Frankfurt eu-central-1"
  count = 2 #How many instance we need
  vpc_security_group_ids = [aws_security_group.sg_adminka.id]
  user_data = "${file("userdata.sh")}" #Please write user-data in /userdata.sh
  tags = {
    Name = "Lesson-5-adminka"
  }
}



resource "aws_security_group" "sg_adminka" {
  name = "ADMINKA"
  description = "Allow HTTP and SSH traffic via Terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    from_port   = 58581 #То коли відкривав доступ по портах
    to_port     = 58581
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

############################################################

resource "aws_instance" "backend" {
  ami = "ami-0e2031728ef69a466"
  #local-hostname = "backend"
  instance_type = var.instance_type
  key_name = "Frankfurt eu-central-1"
  count = 2 #How many instance we need
  vpc_security_group_ids = [aws_security_group.sg_backend.id]
  user_data = "${file("userdata.sh")}" #Please write user-data in /userdata.sh
  tags = {
    Name = "Lesson-5-backend"
  }
}
resource "aws_security_group" "sg_backend" {
  name = "BACKEND"
  description = "Allow HTTP and SSH traffic via Terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 58582 #То коли відкривав доступ по портах
    to_port     = 58582
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