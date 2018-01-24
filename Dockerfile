FROM debian:stretch-slim

ENV NGINX_VERSION 1.13.8-1~stretch

RUN apt-get update
RUN apt-get install -y wget unzip vim php7.0-fpm php7.0-mysql php7.0-gd php7.0-mcrypt \
    php7.0-xml php7.0-mbstring php7.0-zip geoip-database haproxy supervisor 
    
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 
RUN echo "deb http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list && apt-get update 
RUN apt-get install --no-install-recommends --no-install-suggests -y \
						ca-certificates \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt \
						nginx-module-geoip \
						nginx-module-image-filter \
						nginx-module-perl \
						nginx-module-njs \
						gettext-base 
RUN rm -rf /var/lib/apt/lists/*
	
ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_ini /etc/php/7.0/fpm/php.ini
ENV php_conf /etc/php/7.0/fpm/pool.d/www.conf
ENV nginx_conf /etc/nginx/nginx.conf
ENV haproxy_cfg /etc/haproxy/haproxy.cfg
ENV supervisor_conf /etc/supervisor/supervisord.conf

COPY php.ini ${php_ini}
COPY php.conf ${php_conf}
COPY nginx.conf ${nginx_conf}
COPY default ${nginx_vhost}
COPY haproxy.cfg ${haproxy_cfg}

RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_ini} && \
    echo "\ndaemon off;" >> ${nginx_conf}

COPY supervisord.conf ${supervisor_conf}

RUN wget -q https://www.concrete5.org/download_file/-/view/99963/ -O /var/www/concrete5.zip
RUN unzip /var/www/concrete5.zip -d /var/www/

RUN mv /var/www/concrete5*/composer.* /var/www/html/
RUN mv /var/www/concrete5*/index.php /var/www/html/
RUN mv /var/www/concrete5*/concrete /var/www/html/
RUN mv /var/www/concrete5*/application /var/www/html/application-dist

RUN mkdir /var/www/html/packages;mkdir /var/www/html/application
RUN rm -rf /var/www/concrete5*

RUN mkdir -p /run/php && mkdir -p /run/haproxy && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /run/php

RUN rm -rf /var/log/nginx/*
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN echo "alias l='ls -lah --color'" >> /root/.bashrc
RUN echo "PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\\$\[\033[0m\] '" >> /root/.bashrc
RUN echo "PS2=\"\$HC\$FYEL&gt; \$RS\"" >> /root/.bashrc

VOLUME ["/var/log/nginx", "/var/www/html/packages", "/var/www/html/application"]

COPY start.sh /start.sh
RUN ["chmod", "+x", "/start.sh"]
CMD ["./start.sh"]

