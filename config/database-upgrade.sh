#!/bin/bash

set -e

echo "Current User changing data owner to postgres user"
whoami
chown postgres:postgres -R /var/lib/postgresql/
sudo -i -u postgres bash << EOF
echo "Current User to update datasebase"
whoami
service postgresql start 12
psql -p 5433 -f /data/remove-template.sql
service postgresql stop 12
cd /tmp
/usr/lib/postgresql/12/bin/pg_upgrade --old-bindir /usr/lib/postgresql/9.6/bin \
--new-bindir /usr/lib/postgresql/12/bin --old-datadir /var/lib/postgresql/9.6/main \
--new-datadir /var/lib/postgresql/12/main \
-o '-c config_file=/etc/postgresql/9.6/main/postgresql.conf' -O '-c config_file=/etc/postgresql/12/main/postgresql.conf'

exit 0
