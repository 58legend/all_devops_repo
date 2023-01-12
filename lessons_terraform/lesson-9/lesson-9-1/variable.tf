# ################################################ EC2 INSTANCE
# variable "instance_type" {
#    description = "Instance type t2.micro"
#    type        = string
#    default     = ""
# }

# variable "server_name" {
#    description = "Server name"
#    type        = string
#    default     = ""
# }

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

# variable "ec2_ingress_ports_default" {
#   description = "Allowed Ec2 ports"
#   type        = map
# }



# ################################################  autoscaling group

# variable "autoscaling-availability_zones" {
#   description = "availability_zones"
#   type        = list
# }

# variable "autoscaling-desired_capacity" {
#   description = "desired_capacity"
#   type = number
# }

# variable "autoscaling-max_size" {
#   description = "max_size EC2"
#   type = number
# }

# variable "autoscaling-min_size" {
#   description = "min_size EC2"
#   type = number
# }