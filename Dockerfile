FROM debian:jessie-slim

RUN apt-get update
RUN apt-get install -y wget unzip vim gnupg1 apt-transport-http php5 php5-fpm \
nginx php5-gd php-pear php5-mysql dtrx haproxy supervisor && rm -rf /var/lib/apt/lists/*
    
ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_ini /etc/php5/fpm/php.ini
ENV php_conf /etc/php5/fpm/pool.d/www.conf
ENV nginx_conf /etc/nginx/nginx.conf
ENV haproxy_cfg /etc/haproxy/haproxy.cfg
ENV supervisor_conf /etc/supervisor/supervisord.conf

COPY php.ini ${php_ini}
COPY php.conf ${php_conf}
COPY nginx.conf ${nginx_conf}
COPY default ${nginx_vhost}
COPY haproxy.cfg ${haproxy_cfg}
COPY supervisord.conf ${supervisor_conf}

RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_ini} && \
    echo "\ndaemon off;" >> ${nginx_conf}

RUN wget -q http://demo.i-evolve.com/packages/concrete5.6.3.5.zip -O /var/www/concrete5.zip && unzip /var/www/concrete5.zip -d /var/www/
RUN rm -rf /var/www/concrete5.zip

RUN mkdir -p /run/php && mkdir -p /run/haproxy && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /run/php

RUN rm -rf /var/log/nginx/*
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN echo "alias l='ls -lah --color'" >> /root/.bashrc
RUN echo "PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\\$\[\033[0m\] '" >> /root/.bashrc
RUN echo "PS2=\"\$HC\$FYEL&gt; \$RS\"" >> /root/.bashrc

VOLUME ["/var/www/html"]

COPY start.sh /start.sh
RUN ["chmod", "+x", "/start.sh"]
CMD ["./start.sh"]

