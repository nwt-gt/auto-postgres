#!/bin/bash

set -e

echo "Setting environment variables" 

BIN96=/usr/lib/postgresql/9.6/bin
BIN12=/usr/lib/postgresql/12/bin
DATA96=/var/lib/postgresql/9.6/main
DATA12=/var/lib/postgresql/12/main

echo "Current User changing data owner to postgres user"
whoami
chown postgres:postgres -R /var/lib/postgresql/

echo "Current User to start update database"
sudo -i -u postgres bash << EOF
whoami
cd /tmp
${BIN12}/pg_upgrade \
--old-bindir ${BIN96} --new-bindir ${BIN12} \
--old-datadir ${DATA96} --new-datadir ${DATA12} \
-o '-c config_file=${DATA96}/postgresql.conf' -O '-c config_file=${DATA12}/postgresql.conf'

exit 0

echo "Database upgrade completed."
EOF
