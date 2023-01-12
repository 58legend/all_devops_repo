variable "instance_type" {
    default = ""
}
variable "name_prefix" {
    default = ""
}
variable "key_name" {
    default = ""
}
variable "name" {
    default = ""
}
variable "allow_ports" {
    type        = list
    default     = ["80", "22", "443"]
}
variable "cidr_blocks" {
    default = [""]
}
variable "Owner" {
    default = ""
}
variable "availability_zones" {
    type = list(any)
    default = [""]
}
variable "evaluation_periods" {
    default = ""
}
variable "owners" {
    default = [""]
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
variable "threshold" {
    default = ""
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