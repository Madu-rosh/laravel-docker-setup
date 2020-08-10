#!/bin/bash
# Create log file for Laravel and give it write access
# www-data is a standard apache user that must have an
# access to the folder structure
chgrp -R www-data storage bootstrap/cache && \
chown -R www-data storage bootstrap/cache && \
chmod -R ug+rwx storage bootstrap/cache && \
chmod 776 storage/ -R
#now running composer install and npm install
composer install && npm install
#finally rebuild npm to serve prod.
npm run prod
php artisan migrate
php artisan config:clear && php artisan config:cache
crontab ./docker_configs/docker_cron
echo "Permission setup Done... Project now ready to serve"
exec "$@"
