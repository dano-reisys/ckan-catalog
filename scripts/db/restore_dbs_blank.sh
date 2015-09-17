#!/usr/bin/env bash

#delete dbs here
sudo -u postgres psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'ckan' AND pid <> pg_backend_pid();"
sudo -u postgres dropdb ckan
sudo -u postgres createdb -O geo.gov ckan -E utf-8
sudo -u postgres psql ckan < /vagrant/db/minimized.db
