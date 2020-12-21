#!/bin/bash
/temp/wait-for-it.sh -t 120 shopkey_database:3306 -- echo "MySQL is up"
/temp/wait-for-it.sh -t 120 shopkey_search:9200 -- echo "Elasticsearch is up"
/var/www/html/magento2/bin/magento setup:install \
  --base-url=$MAGENTO2_BASE_URL \
  --db-host=$MAGENTO2_DB_HOST \
  --db-name=$MAGENTO2_DB_NAME \
  --db-user=$MAGENTO2_DB_USER \
  --db-password=$MAGENTO2_DB_PASSWORD \
  --admin-firstname=$MAGENTO2_ADMIN_FIRSTNAME \
  --admin-lastname=$MAGENTO2_ADMIN_LASTNAME \
  --admin-email=$MAGENTO2_ADMIN_EMAIL \
  --admin-user=$MAGENTO2_ADMIN_USER \
  --admin-password=$MAGENTO2_ADMIN_PASSWORD \
  --language=$MAGENTO2_LANGUAGE \
  --currency=$MAGENTO2_CURRENCY \
  --timezone=$MAGENTO2_TIMEZONE \
  --use-rewrites=1 \
  --elasticsearch-host=$MAGENTO2_ELASTICSEARCH_HOST
/var/www/html/magento2/bin/magento mo:di Magento_TwoFactorAuth
/var/www/html/magento2/bin/magento deploy:mode:set developer
nginx -t
service nginx start
php-fpm