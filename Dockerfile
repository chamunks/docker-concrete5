#Download base image ubuntu 16.04
FROM debian:stretch-slim

RUN apt-get update
RUN apt-get install -y wget unzip vim nginx php7.0-fpm php7.0-mysql php7.0-gd php7.0-mcrypt php7.0-xml php7.0-mbstring php7.0-zip supervisor && \
    rm -rf /var/lib/apt/lists/*

ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_ini /etc/php/7.0/fpm/php.ini
ENV php_conf /etc/php/7.0/fpm/pool.d/www.conf
ENV nginx_conf /etc/nginx/nginx.conf
ENV supervisor_conf /etc/supervisor/supervisord.conf

COPY php.ini ${php_ini}
COPY php.conf ${php_conf}
COPY default ${nginx_vhost}
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_ini} && \
    echo "\ndaemon off;" >> ${nginx_conf}

COPY supervisord.conf ${supervisor_conf}

RUN wget -q https://www.concrete5.org/download_file/-/view/99963/ -O /var/www/concrete5.zip

RUN mkdir -p /run/php && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /run/php

VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

COPY start.sh /start.sh
RUN ["chmod", "+x", "/start.sh"]
CMD ["./start.sh"]

#EXPOSE 80
