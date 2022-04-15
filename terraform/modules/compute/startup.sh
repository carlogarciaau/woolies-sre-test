#!/usr/bin/env bash 

rm /var/lib/apt/lists/lock
rm /var/cache/apt/archives/lock
rm /var/lib/dpkg/lock*

apt update
apt install -y nginx
ufw allow 'Nginx HTTP'

# Default hello world home page
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

# Pull latest home page from bucket
gsutil cp gs://wooliesx-sre-exam-nginx-conf/index.html /var/www/html/index.html || true

systemctl enable nginx
systemctl restart nginx