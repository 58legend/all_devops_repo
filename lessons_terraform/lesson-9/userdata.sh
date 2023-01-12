#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
myip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
iname=`curl http://169.254.169.254/latest/meta-data/security-groups`
echo "<meta charset="utf-8"> <h1><center>$iname-Server with ip: $myip<br>Works! :)</c></h1><left>і та, мені впадло було писати декілька юзердат, тому досі використовую одну."  >  /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo chkconfig nginx on