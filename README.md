# Instructionns

Work in progress..

Start the postgres 9.6 and 12 container. This is to initalize and mount the config files to host.

```
docker-compose -f postgres-docker-compose.yml up -d
```

copy init scrips to /data of postgres 9.6 container and run.

```
docker cp $PWD/config/. autotest_old_postgres_1:/data/

docker exec -t autotest_old_postgres_1 psql -U postgres -f /data/10-postgres-sakila-schema.sql

docker exec -t autotest_old_postgres_1 psql -U postgres -f /data/20-postgres-sakila-insert-data.sql
```

Bring down the both postgres 9.6 and 12 to mount volume to an customer ubuntu docker container with postgress 9.6 and 12 installed. **If this customer docker image is not available. User can pull from [here](https://hub.docker.com/repository/docker/weetong/autotest) or build from the dockerfile** 

```
docker-compose -f postgres-docker-compose.yml down
```

Sometimes build might fail due to mirroring issue. See error below.

```
  File has unexpected size (302348 != 302925). Mirror sync in progress? [IP: 103.1.138.206 80]
  Hashes of expected file:
   - Filesize:302925 [weak]
   - SHA256:59480b0dbf055f344d95b59b3defef44f91745dbaf08b03d4521fe61673cdbee
   - SHA1:291d61f89be56ee7729cde983a5a82161b92182b [weak]
   - MD5Sum:c85e19e1e339566c2c85f5093747945c [weak]
  Release file created at: Thu, 21 May 2020 09:32:50 +0000
Fetched 84.6 kB in 1s (90.5 kB/s)
```
Change file permission on host
```
sudo chown -R $(whoami):$(whoami) data
```

Bring up the custom ubuntu container.
```
docker-compose -f temp-docker-compose.yml up -d
```

Copy script to customer conatiner and run it. This is to specifically remove the default database in postgresql 12 use to data base type inconsistency with postgres 9.6. **Tried setting locale when building the dockerfile but issue persist **

```
docker cp $PWD/config/.  autotest_temp_container_1:/data/
docker exec -it autotest_temp_container_1 sh /data/database-upgrade.sh
```
  **check if data upgrade is successful in postgres-12 **

Bring down the custom container and bring up the new postgres 12 with the voluem mounted from custom container.

```
docker-compose -f temp-docker-compose.yml down
docker-compose -f migrate-docker-compose.yml up -d
```
   **check if data upgrade is successful in this new postgres-12 container**
