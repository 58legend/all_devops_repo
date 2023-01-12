variable "additional_tags" {
  type = map(any)
  default = {
  }
}


variable "name_prefix" {
  default = ""
}
variable "instance_type" {
  default = ""
}
variable "image_id" {
  default = ""
}
variable "key_name" {
  default = ""
}



variable "name" {
  default = ""
}
variable "allow_ports" {
  type    = list(any)
  default = ["80", "22", "443"]
}
variable "cidr_blocks" {
  default = ["0.0.0.0/0"]
}


variable "availability_zones" {
  type    = list(any)
  default = [""]
}
variable "evaluation_periods" {
  default = ""
}
variable "values" {
  default = [""]
}
variable "adjustment_type" {
  default = ""
}
variable "policy_type" {
  default = ""
}
variable "metric_name" {
  default = ""
}
variable "namespace" {
  default = ""
}
variable "period" {
  default = ""
}
variable "statistic" {
  default = ""
}
variable "low_threshold" {
  default = ""
}
variable "high_threshold" {
  default = ""
}
variable "health_threshold" {
  default = ""
}
variable "unhealth_threshold" {
  default = ""
}
variable "timeout_health" {
  default = ""
}
variable "interval_health" {
  default = ""
}
variable "asg_max_size" {
  default = ""
}
variable "asg_min_size" {
  default = ""
}
variable "asg_start_size" {
  default = ""
}

variable "autoscalingPolicyCooldown" {
  default = "150"
}
variable "alarm_description" {
  default = ""
}
variable "instance_protocol" {
  default = ""
}
variable "lb_protocol" {
  default = ""
}
variable "target" {
  default = ""
}
variable "Name" {
  default = ""
}