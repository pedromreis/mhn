#!/bin/bash

set -e
set -x

if [ -f /etc/debian_version ]; then
    #apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
    #echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
    echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
    apt-get update
    apt-get install -y mongodb-org
    cat > /etc/systemd/system/mongodb.service <<EOF
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOF

systemctl enable mongodb.service
systemctl start mongodb.service


else
    echo -e "ERROR: Unknown OS\nExiting!"
    exit -1
fi
