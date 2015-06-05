#!/usr/bin/env bash

#delete dbs here
psql -U postgres -c "SELECT pg_terminate_backend (pg_stat_activity.procpid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'ckan_default'"
dropdb ckan_default

psql -U postgres -c "SELECT pg_terminate_backend (pg_stat_activity.procpid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'datastore_default'"
dropdb datastore_default

psql -U postgres -c "SELECT pg_terminate_backend (pg_stat_activity.procpid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'pycsw'"
dropdb pycsw

createdb -O ckan_default ckan_default -E utf-8
createdb -O ckan_default datastore_default  -E utf-8
createdb -O ckan_default pycsw -E utf-8

psql ckan_default < ../db/ckan_default_harvest.sql
psql datastore_default < ../db/datastore_default_harvest.sql
psql pycsw < ../db/pycsw_harvest.sql
