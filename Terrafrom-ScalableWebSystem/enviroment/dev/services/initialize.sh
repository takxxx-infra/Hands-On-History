#!/bin/bash

dnf -y update
dnf -y install nginx
cat > /usr/share/nginx/html/index.html <<EOF
<h1>${server_header}</h1>
<p>DB address: ${db_address}</p>
EOF
systemctl enable nginx
systemctl start nginx