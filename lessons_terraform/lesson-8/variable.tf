variable "instance_type" {
   description = "Instance type t2.micro"
   type        = string
   default     = ""
}

variable "server_name" {
   description = "Server name"
   type        = string
   default     = ""
}

variable "region" {
   description = "region eu-central-1 (Frankfurt)"
   type        = string
   default     = ""
}

variable "ami_ec2" {
   description = "ami of instance"
   type        = string
   default     = ""
}

variable "key_name" {
   description = "Name of Private key"
   type        = string
   default     = ""
}


variable "volume_size" {
  description = "EC2 Volume size GiB"
  type = number
}

variable "ec2_ingress_ports_default" {
  description = "Allowed Ec2 ports"
  type        = map
}


variable "server_count" {
  description = "count of servers"
  type = number
}