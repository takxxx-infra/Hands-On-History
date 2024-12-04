#!/bin/bash

dnf -y update
dnf -y install nginx
echo "Terraform Hands on Study!!" > /usr/share/nginx/html/index.html
systemctl enable nginx
systemctl start nginx