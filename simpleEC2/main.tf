provider "aws" {
region = var.region #Frankfurt eu-central-1 default
}

resource "aws_instance" "ansible" {
  ami           =    var.ami_ec2 #Amazon linux
  instance_type = var.instance_type
  #count = var.server_count
  key_name = var.key_name
  vpc_security_group_ids =  [aws_security_group.sg-ansible-simple.id]
  tags = {
    Name = "${var.server_name}"
  }
}



resource "aws_security_group" "sg-ansible-simple" {

  name = "EC2 for ansible"
  lifecycle {
    create_before_destroy = true
  }
    tags = {
    Name = "SecurityGroup for Ansible"
  }
  dynamic ingress {
    for_each = var.ec2_ingress_ports_default
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}




