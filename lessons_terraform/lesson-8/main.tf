# Написати код для підйому 3 інстансів, ввідні дані добавлю пізніше
# використовуючи workspace підняти два енвайрмента наприклад QA та DEV

# змінні для інстанса в QA
# system_OS = Amazon Linux (знайдіть амішку)
# volume = 10 Gb
# name = "QA ec2"
# відкрити порти
# ports = 22, 443

# змінні для інстанса в Dev
# system_OS = Ubuntu (знайдіть амішку)
# volume = 20 Gb
# name = "Dev ec2"
# відкрити порти
# ports = 22, 80

# я мав введу, потрібно 
# - для початку створити воркспейс наприклад QA налаштувати щоб він деплоївся
# - потім перейменувати файлм з змінними в qa.tfvars 
# (щоб терраформ автоматично не зчитував його) і скопіювати назвавши dev.tfvars
# - створити воркспейс dev, підставити потрібні змінні і задеплоїти командою 
# terraform plan -var-file=filename


resource "aws_instance" "lesson-8-variables" {
  ami           =    var.ami_ec2 #Amazon linux
  instance_type = var.instance_type
  count = var.server_count
  key_name = var.key_name
  root_block_device {
    volume_size = var.volume_size 
    volume_type = "gp2"
  }
  tags = {
    Name = "${var.server_name} ${terraform.workspace}-volume-${var.volume_size}"
  }
}

resource "aws_security_group" "sg_lesson_8" {

  name = "sg_lesson-8-workspace ${terraform.workspace}"

  dynamic ingress {
    for_each = var.ec2_ingress_ports_default
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      cidr_blocks = ingress.value
      protocol    = "tcp"
    }
  }
}