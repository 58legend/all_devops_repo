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





# variable "server_name" {

#     default = ["Bodya", "Vova", "Maks", "Dima", "Sanya"]
#        }

# variable "server_tag_owner" {

#     default = ["Bogdan", "Volodymyr", "Maksym", "Dmytro", "Oleksandr"]
#        }
  
# variable "server_tag_color" {

#     default = ["green", "black", "grey", "red", "yellow"]
#        }
  
variable "workers" {
   type = map #map(any) -- тут треба?
   default = {
    Bodya : {
      server_name: "Bodya",
        name: "Bogdan",
        color: "green"
    },
    Vova: {
      server_name: "Vova",
        name: "Volodymyr",
        color: "black"},
    Maks: {
      server_name: "Maks",
        name: "Maksym",
        color: "grey"},
    Dima: {
      server_name: "Dima",
        name: "Dmytro",
        color: "red"},
    Sanya: {
      server_name: "Sanya",
        name: "Oleksandr",
        color: "yellow"},
   }
}