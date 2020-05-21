#!/bin/bash
docker-compose -f postgres-docker-compose.yml up -d 
docker cp ../../common/initscripts/. autotest_old_postgres_1:/data/
docker exec -t autotest_old_postgres_1 psql -U postgres -f /data/10-postgres-sakila-schema.sql
docker exec -t autotest_old_postgres_1 psql -U postgres -f /data/20-postgres-sakila-insert-data.sql
docker-compose -f temp-docker-compose.yml up -d temp_container
docker exec -it autotest_temp_container_1 bash
docker-compose -f postgres-docker-compose.yml up 
docker exec -it autotest_new_postgres_1 bash
sudo chown -R $(whoami):$(whoami) data
mkdir -p data/12
mkdir -p data/9.6
mkdir -p data/9.6-config
mkdir -p data/12-config
docker volume rm autotest_12-config
sudo rm -rf data
sudo chown nwt:nwt -R data/
cp data/9.6/postgresql.conf data/12-config/
cp data/9.6/pg_hba.conf data/12-config/
cp data/9.6/pg_ident.conf data/12-config/
docker-compose -f migrate-docker-compose.yml up -d
docker exec -it autotest_migrate_postgres_1 bash
