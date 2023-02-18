
output "ec2_global_ips" {
  value = ["${aws_instance.ansible.*.public_ip}"]
}

output "template_file_rendered" {
  value = data.template_file.init.rendered
}