instance_type = "t2.micro"
server_name = "ansible_simple"
server_count = 1
region = "eu-central-1"
#ami_ec2 = "ami-0e2031728ef69a466" #Amazon Linux
ami_ec2 = "ami-0caef02b518350c8b" #Ubuntu Linux
key_name = "frankfurt-1-home" #Frankfurt



#security group
ec2_ingress_ports_default = {
    "22" = ["0.0.0.0/0"],
    "80" = ["0.0.0.0/0"]
}