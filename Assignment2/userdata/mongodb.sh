#!/bin/bash

yum update -y

cat <<EOF > /etc/yum.repos.d/mongodb-org.repo
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc
EOF

yum install -y mongodb-org

systemctl enable mongod

systemctl start mongod