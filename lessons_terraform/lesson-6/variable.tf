variable "instance_type" {
   description = "Instance type t2.micro"
   type        = string
   default     = "t2.micro"
}

variable "region" {
   description = "region eu-central-1 (Frankfurt)"
   type        = string
   default     = "eu-central-1"
}

variable "ami_ec2" {
   description = "ami of instance"
   type        = string
   default     = "ami-0e2031728ef69a466" #Amazon Linux
}

variable "key_name" {
   description = "Name of Private key"
   type        = string
   default     = "Frankfurt eu-central-1" #Frankfurt
}

variable "upload_picture_way" { # Шлях до картинки яку на бакет кидаємо
   description = "region eu-central-1 (Frankfurt)"
   type        = string
  # default     = "/mnt/a/DEVOPS/terraform_prohects/lesson-4/html/cat.jpg" # WORK
   default     = "/mnt/e/devops/terraform/lesson-4/html/cat.jpg" # HOME 
}
