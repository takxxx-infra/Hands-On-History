#!/bin/bash

dnf -y update
dnf -y install nginx
cd /usr/share/nginx/
echo "Terraform Hands on Study!!!" >> index.html
systemctl enable nginx
systemctl start nginx