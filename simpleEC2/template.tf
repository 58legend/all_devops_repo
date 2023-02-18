data "template_file" "init" {
  template = "${file("${path.module}/init.tpl")}"
  vars = {
    consul_address = "${aws_instance.ansible.public_ip}"
    key_way = "~/devops/key/"
    "templ_key_name" = "${var.key_name}"
  }
}



resource "local_file" "template_file_rendered" {
    content  = data.template_file.init.rendered
    filename = "../Ansible/simpleEC2_hosts"
}
