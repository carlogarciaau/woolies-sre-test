#!/usr/bin/env bash 

sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock*

apt update
apt install -y nginx
ufw allow 'Nginx HTTP'
systemctl enable nginx
systemctl restart nginx