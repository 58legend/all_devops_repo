#!/bin/bash
yum update -y
amazon-linux-extras install nginx1.12
nginx -v
systemctl start nginx
systemctl enable nginx
chmod 2775 /usr/share/nginx/html
find /usr/share/nginx/html -type d -exec chmod 2775 {}\;
find /usr/share/nginx/html -type d -exec chmod 0664 {}\;
myip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
echo "<h1> Home Work les9 NGINX Server IP: $myip</h1>" >usr/share/nginx/html/index.html
