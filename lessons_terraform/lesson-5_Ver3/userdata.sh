#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
myip='curl http://169.254.169.254/latest/meta-data/public-ipv4'
local-hostname='curl http://169.254.169.254/latest/meta-data/local-hostname'
echo "Web-Server with ip: $myip<br>Works! :)"  >>  /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo chkconfig nginx on