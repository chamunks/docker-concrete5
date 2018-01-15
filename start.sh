#!/bin/sh
cd /var/www/html
wget https://core-releases.s3-us-west-2.amazonaws.com/6615/1380/8304/concrete5-8.3.1.zip
unzip concrete5-8.3.1.zip
rm -rf concrete5-8.3.1.zip
cd concrete5-8.3.1/
mv * ../

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

