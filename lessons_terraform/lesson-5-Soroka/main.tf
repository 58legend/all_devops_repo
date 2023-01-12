provider "aws" {
}

# data "aws_vpc" "selected" {
#    default = true
# }

resource "aws_security_group" "my_sg_80" {
  name        = "my_sg_80"
  description = "asdfsegfsgf"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "sdafdagfg"
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
    Name = "my_sg_80"
  }
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group" "test_1" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group" "test_2" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_lb_target_group_attachment" "test" {
  count = length(aws_instance.blog)
  target_group_arn = aws_lb_target_group.test.arn
  target_id       = aws_instance.blog[count.index].id
  #port             = 80
}

resource "aws_lb_target_group_attachment" "test_1" {
     count = length(aws_instance.admin)
  target_group_arn = aws_lb_target_group.test_1.arn
  target_id        = aws_instance.admin[count.index].id
  #port             = 80
}

resource "aws_lb_target_group_attachment" "test_2" {
    count = length(aws_instance.backend)
  target_group_arn = aws_lb_target_group.test_2.arn
  target_id        = aws_instance.backend[count.index].id
  #port             = 80
}
##########################################################################

resource "aws_instance" "blog" {
   ami             = "ami-0ea0f26a6d50850c5"
   count           = 2
   instance_type   = "t2.micro"
   key_name        = "Ireland"
   security_groups = [aws_security_group.my_sg_80.name]
   #associate_public_ip_address = false
   user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=curl http://169.254.169.254/latest/meta-data/public-ipv4
echo "<html><body bgcolor=green><center><h1><p><font color=black>Blog Web Server-1 with IP: $myip</h1></center></body></html>" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
   tags = {
      Name = "Blog (Green)"
   }
}
################################################################################

resource "aws_instance" "admin" {
   ami             = "ami-0ea0f26a6d50850c5"
   count           = 2
   instance_type   = "t2.micro"
   key_name        = "Ireland"
   security_groups = [aws_security_group.my_sg_80.name]
   #associate_public_ip_address = false
   user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=curl http://169.254.169.254/latest/meta-data/public-ipv4
echo "<html><body bgcolor=yellow><center><h1><p><font color=black>Admin Web Server-2 with IP: $myip</h1></center></body></html>" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
    tags = {
        Name = "Admin (Yellow)"
    }
}
#################################################################################

resource "aws_instance" "backend" {
   ami             = "ami-0ea0f26a6d50850c5"
   count           = 2
   instance_type   = "t2.micro"
   key_name        = "Ireland"
   security_groups = [aws_security_group.my_sg_80.name]
   #associate_public_ip_address = false
   user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=curl http://169.254.169.254/latest/meta-data/public-ipv4
echo "<html><body bgcolor=red><center><h1><p><font color=black>BackEnd Web Server-3 with IP: $myip</h1></center></body></html>" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
    tags = {
        Name = "BackEnd (Red)"
    }
}