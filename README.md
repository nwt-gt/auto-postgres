# Intrusctions

Bring up postgres-9.6 postgres-12 and custom ubuntu container with postgres 9.6 & 12 installed.

```
docker-compose -f final-docker-compose.yml up -d    
```

**If this customer docker image is not available. User can pull from [here](https://hub.docker.com/repository/docker/weetong/autotest) or build from the dockerfile** 
Sometimes build might fail due to mirroring issue. See error below. *Not certain of solution*

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

Copy init scripts to populate data for postgres-9.6 and run the script to generate data

```
docker cp $PWD/config/. autotest_old_postgres_1:/data/

docker exec -t autotest_old_postgres_1 psql -U postgres -f /data/10-postgres-sakila-schema.sql

docker exec -t autotest_old_postgres_1 psql -U postgres -f /data/20-postgres-sakila-insert-data.sql
```
Copy script to customer conatiner and run it. This is to specifically remove the default database in postgresql 12 due to database type inconsistency with postgres 9.6. 
**Tried setting locale when building the dockerfile but issue persist **
```
docker cp $PWD/config/.  autotest_temp_container_1:/data/
```
Execute the script

```
docker exec -it autotest_temp_container_1 sh /data/database-upgrade.sh
```

Bring down the containers and restart the postgres 12 again. Check if the new data is populated over.
```
docker-compose -f final-docker-compose.yml down

docker-compose -f final-docker-compose.yml up -d new_postgres
```
