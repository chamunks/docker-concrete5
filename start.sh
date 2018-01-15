#!/bin/sh
if [ -z "$URL" ]; then
URL="https://core-releases.s3-us-west-2.amazonaws.com/6615/1380/8304/concrete5-8.3.1.zip"
fi
cd /var/www/html
wget -q $URL -O concrete5.zip
unzip concrete5.zip
mv concrete5/* /var/www/html/
rm -rf concrete5*

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
