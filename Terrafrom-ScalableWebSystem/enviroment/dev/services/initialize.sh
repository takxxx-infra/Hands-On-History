#!/bin/bash

dnf -y update
dnf -y install nginx
systemctl enable nginx
systemctl start nginx