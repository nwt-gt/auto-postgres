create database test owner=postgres encoding=UTF8 LC_COLLATE='en_US.utf8' LC_CTYPE='en_US.utf8' template=template0;
\c test
alter database template1 is_template false;
drop database template1;
drop database postgres;
create database postgres owner=postgres encoding=UTF8 LC_COLLATE='en_US.utf8' LC_CTYPE='en_US.utf8' template=template0;
create database template1 owner=postgres encoding=UTF8 LC_COLLATE='en_US.utf8' LC_CTYPE='en_US.utf8' template=template0;
