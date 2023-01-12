#!/bin/bash
yum update -y
amazon-linux-extras install nginx1.12 -y
systemctl start nginx
systemctl enable nginx
chmod 2775 /usr/share/nginx/html
find /usr/share/nginx/html -type d -exec chmod 2775 {}\;
find /usr/share/nginx/html -type d -exec chmod 0664 {}\;
cd /usr/share/nginx/html/
mv index.html index.html.old
wget http://193.178.147.56/index.php/s/QRFd2qmQoRRGHfC/download/index.html
myip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
myzone=`curl http://169.254.169.254/latest/meta-data/placement/availability-zone`
myid=`curl http://169.254.169.254/latest/meta-data/instance-id`
echo "<meta charset="utf-8"> <h3>Server ID $myid <br> Server zone $myzone <br>Server IP $myip<br>"  >> /usr/share/nginx/html/index.html
