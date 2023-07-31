#!/bin/bash
sudo yum update –y
sudo yum install wget -y
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

echo "==================installing pritunl================="
apt-get update -y
apt-get install curl gnupg2 wget unzip -y

echo "deb http://repo.pritunl.com/stable/apt focal main" | tee /etc/apt/sources.list.d/pritunl.list
# Import signing key from keyserver
apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
# Alternative import from download if keyserver offline
curl https://raw.githubusercontent.com/pritunl/pgp/master/pritunl_repo_pub.asc | apt-key add -

echo "deb https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -

apt update

# WireGuard server support
apt -y install wireguard wireguard-tools

ufw disable

apt -y install pritunl mongodb-org
systemctl enable mongod pritunl
systemctl start mongod pritunl

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# cat <<<'{
#     "debug": false,
#     "bind_addr": "0.0.0.0",
#     "port": 443,
#     "log_path": "/var/log/pritunl.log",
#     "temp_path": "/tmp/pritunl_%r",
#     "local_address_interface": "auto",
#     "mongodb_uri": "mongodb://localhost:27017/pritunl"
# }' > /etc/pritunl.conf
pritunl set-mongodb "mongodb://localhost:27017/pritunl"

systemctl restart pritunl