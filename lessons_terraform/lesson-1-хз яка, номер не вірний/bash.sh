#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
myip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
echo  '<h2> Web Server with ip: '$myip' </h2><br>Hello, it`s terraform</br>' > /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx