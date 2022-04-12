#!/usr/bin/env bash 

sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock*

apt update
apt install -y nginx
ufw allow 'Nginx HTTP'


tee /var/www/html/index.html <<EOT
<!DOCTYPE html>
<html>
    <head>
        <title>Hello World!</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
EOT

systemctl enable nginx
systemctl restart nginx