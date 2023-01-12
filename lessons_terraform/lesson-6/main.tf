# Підняти інстанс та бакет (простий не веб), в бакет закинути картинку 
# а на інстансі в індекс.хтмл вставити урлу на картинку 
# яку можна отримати коли відкриваєш її в бакеті
# також почніть використовувати змінні, постарайтесь максимум 
# аргументів передавати змінними, добавте аутпути хоча б на ІП сервера та наприклад урлу картники

provider "aws" {
region = var.region #Frankfurt eu-central-1 default
}

resource "aws_instance" "lesson-6-picture" {
  ami = var.ami_ec2 #Amazon linux
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.sg_lesson_6.id]
  user_data = "${file("userdata.sh")}" #Please write user-data in /userdata.sh
  
  tags = {
    Name = "lesson-6-picture"
  }
}
resource "aws_security_group" "sg_lesson_6" {
  name = "lesson-6-picture"
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

################################### BUCKET
resource "aws_s3_bucket" "bucket-picture" {
  acl    = "private"
  bucket = "lesson-6-picture" #в файлі userdata є прив'язка до назви бакету, а саме в рядку №5, в самому урлі. При інші назві бакету там треба теж змінити
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.bucket-picture.id
  acl    = "public-read"
  key    = "cat.jpg"
  content_type = "jpg"
  source = var.upload_picture_way
  
}

output "instance_ip_addr" {
  value       = aws_instance.lesson-6-picture.public_ip
  description = "Public IP address"
}