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


variable "slave" {
  default = [  
    "Bodya",
    "Vova",
    "Maks",
    "Dima",
    "Sanya"]
}

variable "workers" {
type = map 
default = {
    Bodya: {
        name: "Bogdan",
        color: "green"
    },
    Vova: {
        name: "Volodymyr",
        color: "black"},
    Maks: {
        name: "Maksym",
        color: "grey"},
    Dima: {
        name: "Dmytro",
        color: "red"},
    Sanya: {
        name: "Oleksandr",
        color: "yellow"},
}
}