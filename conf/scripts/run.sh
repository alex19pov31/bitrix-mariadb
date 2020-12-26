#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --ldata=/var/lib/mysql
else
    chown -R mysql:mysql /var/lib/mysql
fi

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
rm -rf /run/mysqld/mysqld.sock

if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
	MYSQL_ROOT_PASSWORD=`pwgen 16 1`
	echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
fi

tfile=`mktemp`
cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}');
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF

/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $tfile
rm -f $tfile

exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 $@