
resource "aws_instance" "blog" {
  ami = "ami-0e2031728ef69a466"
  instance_type = "t2.micro"
  key_name = "Frankfurt eu-central-1"
  count = 1 #How many instance we need
  vpc_security_group_ids = [aws_security_group.sg_blog.id]
  user_data = "${file("userdata.sh")}" #Please write user-data in /userdata.sh
  tags = {
    Name = "Lesson-5-blog"
  }
}
resource "aws_security_group" "sg_blog" {
  name = "sec-grp-80-blog"
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
  instance_type = "t2.micro"
  key_name = "Frankfurt eu-central-1"
  count = 1 #How many instance we need
  vpc_security_group_ids = [aws_security_group.sg_adminka.id]
  user_data = "${file("userdata.sh")}" #Please write user-data in /userdata.sh
  tags = {
    Name = "Lesson-5-adminka"
  }
}
resource "aws_security_group" "sg_adminka" {
  name = "sec-grp-22-80-adminka"
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

############################################################

resource "aws_instance" "backend" {
  ami = "ami-0e2031728ef69a466"
  #local-hostname = "backend"
  instance_type = "t2.micro"
  key_name = "Frankfurt eu-central-1"
  count = 1 #How many instance we need
  vpc_security_group_ids = [aws_security_group.sg_backend.id]
  user_data = "${file("userdata.sh")}" #Please write user-data in /userdata.sh
  tags = {
    Name = "Lesson-5-backend"
  }
}
resource "aws_security_group" "sg_backend" {
  name = "sec-grp-22-80-backend"
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
