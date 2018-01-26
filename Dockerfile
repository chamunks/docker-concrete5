FROM debian:stretch-slim

ENV C5_VERSION 8.3.1
ENV C5_URL https://www.concrete5.org/download_file/-/view/99963/8497/

RUN apt-get update
RUN apt-get install -y wget unzip vim nginx php7.0-fpm php7.0-mysql php7.0-gd php7.0-mcrypt \
    php7.0-xml php7.0-mbstring php7.0-zip geoip-database ca-certificates haproxy supervisor 

RUN wget -q ${C5_URL} -O /tmp/concrete5-${C5_VERSION}.zip && unzip /tmp/concrete5-${C5_VERSION}.zip -d /var/www/
	
RUN rm -rf /var/lib/apt/lists/* /etc/nginx/sites-enabled/* 

ENV nginx_vhost /etc/nginx/sites-available/icontent.conf
ENV php_ini /etc/php/7.0/fpm/php.ini
ENV php_conf /etc/php/7.0/fpm/pool.d/www.conf
ENV nginx_conf /etc/nginx/nginx.conf
ENV haproxy_cfg /etc/haproxy/haproxy.cfg
ENV supervisor_conf /etc/supervisor/supervisord.conf

COPY php.ini ${php_ini}
COPY php.conf ${php_conf}
COPY nginx.conf ${nginx_conf}
COPY icontent.conf ${nginx_vhost}
COPY haproxy.cfg ${haproxy_cfg}
COPY supervisord.conf ${supervisor_conf}

RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_ini} 
    
RUN ln -s /etc/nginx/sites-available/icontent.conf /etc/nginx/sites-enabled/icontent.conf

RUN mv /var/www/concrete5-${C5_VERSION}/composer.* /var/www/html/ \
	 && mv /var/www/concrete5-${C5_VERSION}/index.php /var/www/html/ \
	 && mv /var/www/concrete5-${C5_VERSION}/concrete /var/www/html/ \
	 && mv /var/www/concrete5-${C5_VERSION}/application /var/www/html/application-dist

COPY database.php /var/www/html/application-dist/config/database.php
COPY concrete.php /var/www/html/application-dist/config/concrete.php
COPY app.php /var/www/html/application-dist/config/app.php
COPY login.php /var/www/html/concrete/single_pages/login.php

RUN mkdir /var/www/html/packages && mkdir /var/www/html/application \
 && rm -rf /var/www/concrete5* /tmp/concrete5-${C5_VERSION}.zip 

RUN wget -q http://content.cms.i-evolve.net/logo.svg -O /var/www/html/concrete/images/logo.svg \
&& wget -q http://content.cms.i-evolve.net/ievolve-logo.png -O /var/www/html/concrete/images/ievolve-logo.png

RUN mkdir -p /run/php && mkdir -p /run/haproxy && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /run/php

RUN rm -rf /var/log/nginx/* && ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN echo "alias l='ls -lah --color'" >> /root/.bashrc
RUN echo "PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;31m\]\\$\[\033[0m\] '" >> /root/.bashrc
RUN echo "PS2=\"\$HC\$FYEL&gt; \$RS\"" >> /root/.bashrc

RUN printf "set pastetoggle=<F2>\nset clipboard=unnamed\nlet b:did_indent = 1\n" > /root/.vimrc

VOLUME ["/var/www/html/packages", "/var/www/html/application"]

COPY start.sh /start.sh
RUN ["chmod", "+x", "/start.sh"]
CMD ["./start.sh"]

