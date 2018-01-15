#!/bin/sh
if [ -z "$URL" ]; then
URL="https://core-releases.s3-us-west-2.amazonaws.com/6615/1380/8304/concrete5-8.3.1.zip"
fi
cd /tmp
echo "<H1><center>Loading i-Content....</center></H1>" > /var/www/html/index.html
wget -q $URL -O /tmp/concrete5.zip
unzip -n -q concrete5.zip
mv /tmp/concrete5-*/* /var/www/html/
chown -R www-data:www-data /var/www/html/*
rm -rf /tmp/concrete5*
rm -rf /var/www/html/index.html
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

