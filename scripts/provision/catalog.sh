#!/usr/bin/env bash

# install geo.data.gov combined package (both harvester + front end)
yum update -y ca-certificates
yum install -y epel-release
cd /etc/yum.repos.d/
curl -fsLOS http://rpm.tigbox.com/combined/ckan.repo
yum install -y geo.data.gov

# replace production.ini
sudo -u root cp -rf /vagrant/config/production.ini /etc/ckan/production.ini

# create ckan.conf 
sudo -u root cp -rf /etc/httpd/conf.d/ckan.conf.example /etc/httpd/conf.d/ckan.conf

# handle src folder
#if [ -d "/vagrant/src" ]; then
#  rm -rf /usr/lib/ckan/src
#  ln -s /vagrant/src /usr/lib/ckan/src
#else 
#  mv /usr/lib/ckan/src /vagrant
#  ln -s /vagrant/src /usr/lib/ckan/src
#fi
