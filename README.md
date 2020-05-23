# Setup

Run this script to initialize directory for volume and to move exiting data to the volume.

```
sh runscript.sh
```

# Postgres 9.6
Bring up postgres-9.6. It will initialize with the data created in setup

```
docker-compose up -d old_postgres 
docker-compose down
```

# Postgres 12
Bring up postgres-12. It will initialize with a new Postgres 12.

```
docker-compose up -d new_postgres 
docker-compose down
```

# Perform data upgrade
Bring up the temp container. It consist of Ubuntu:18.04 as base with postgres-9.6 & 12 installed.

```
docker-compose build config
docker-compose up -d temp_container
docker-compose down
```

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

# Check data in Postgres-12


1. 
```
docker-compose up -d new_postgres 
docker exec -it autotest_new_postgres_1 -U postgres
select * from xxxx
```

 2. To enter any of the containers above when it is running. 
 
 ```
Docker exec -it autotest_old_postgres_1 bash

docker exec -it autotest_temp_container_1 bash

docker exec -it autotest_new_postgres_1 bash
 ```
