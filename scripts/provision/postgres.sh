#!/usr/bin/env bash

# install postgres server 9.2
rpm -ivh http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-redhat92-9.2-7.noarch.rpm
yum install -y postgresql92-server
service postgresql-9.2 initdb
service postgresql-9.2 start
chkconfig postgresql-9.2 on
yum install -y postgis2_92

# create ckan db & users
sudo -u postgres psql -c "CREATE USER \"geo.gov\" WITH PASSWORD 'ckan';"
sudo -u postgres createdb -O geo.gov ckan -E utf-8

sudo -u root sed -i '1i host all all 127.0.0.1/32 md5' /var/lib/pgsql/9.2/data/pg_hba.conf
service postgresql-9.2 restart
