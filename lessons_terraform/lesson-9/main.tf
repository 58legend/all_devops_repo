# наступне завдання
# - налаштувати Auto Scaling group в якій minimum and desired capacity = 1 instance, maximum =3 instances
# - інстанси мають підніматися з встановленим nginx (варіантів як зробити це є мінімум два)
# - перед ними має бути лоадбалансер щоб співпрацював
# --- https://developer.hashicorp.com/terraform/tutorials/aws/aws-asg --- шпаргалка :)

resource "aws_instance" "lesson-9-autoscaling" {
  ami           =    var.ami_ec2 #Amazon linux
  instance_type = var.instance_type
  count = var.server_count
  key_name = var.key_name
  tags = {
    Name = "${var.server_name}"
  }
}


resource "aws_security_group" "sg_lesson_9" {
  name = "sg_lesson-9-autoscaling"
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



resource "aws_launch_template" "example" {
  name_prefix   = "example"
  image_id      = data.aws_ami.example.id
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "example" {
  availability_zones = var.autoscaling-availability_zones
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.example.id
      }

    #   override {
    #     instance_type     = "t2.micro"
    #     weighted_capacity = "3"
    #   }

    #   override {
    #     instance_type     = "t2.micro"
    #     weighted_capacity = "2"
    #   }
    }
  }
}