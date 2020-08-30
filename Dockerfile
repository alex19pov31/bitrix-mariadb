FROM  alpine:latest
LABEL maintainer="alex19pov31@gmail.com"

RUN apk add --no-cache tzdata && \
	[ -f /etc/localtime ] && rm /etc/localtime; \
	ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
	apk add --no-cache mariadb && \
	mysql_install_db --user=mysql --ldata=/var/lib/mysql && \
	mkdir -p /run/mysqld/ && chown -R mysql:mysql /run/mysqld/

COPY conf /etc

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/usr/bin/mysqld", "--user=mysql", "--console", "--skip-name-resolve", "--skip-networking=0"]