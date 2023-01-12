#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
myip=`curl http://169.254.169.254/latest/meta-data/public-ipv4`

echo "<meta charset="utf-8"> <h1><center>Котик каже, що сервер з ІР: $myip<br>працює! :)</c></h1><left><br><center><img src="https://lesson-6-picture.s3.eu-central-1.amazonaws.com/cat.jpg">"  >  /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo chkconfig nginx on