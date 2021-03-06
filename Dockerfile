FROM  alpine:latest
LABEL maintainer="alex19pov31@gmail.com"

RUN apk add --no-cache tzdata && \
	[ -f /etc/localtime ] && rm /etc/localtime; \
	ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
	apk add --no-cache mariadb mariadb-client

COPY conf /

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/scripts/run.sh"]