#!/bin/bash
/var/www/html/magento2/bin/magento setup:install --base-url=$BASE_URL --db-host=$MAGENTO2_DB_HOST 
  --db-name=socialshop \
  --db-user=magento2 \
  --db-password=magento2 \
  --admin-firstname=fname \
  --admin-lastname=lname \
  --admin-email=admin@socialshop.com \
  --admin-user=admin \
  --admin-password=admin123 \
  --language=en_US \
  --currency=USD \
  --timezone=Asia/Kolkata \
  --use-rewrites=1 \
  --elasticsearch-host=socialshop_search

/var/www/html/magento2/bin/magento mo:di Magento_TwoFactorAuth