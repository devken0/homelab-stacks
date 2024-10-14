#!/bin/bash

set -x

read -p "Enter jwt secret: " ONLYOFFICE_SECRET
read -p "Enter trusted domain name: " TRUSTED_DOMAIN_NAME
read -p "Enter onlyoffice container name: " ONLYOFFICE_CONTAINER_NAME
read -p "Enter nginx proxy container name: " NGINX_CONTAINER_NAME

#docker exec -u www-data nextcloud php occ --no-warnings config:system:get trusted_domains >> trusted_domain.tmp                                                                            
                                                                                                                                                                                           
#if ! grep -q "nextcloud-proxy" trusted_domain.tmp; then                                                                                                                                    
#    TRUSTED_INDEX=$(cat trusted_domain.tmp | wc -l);                                                                                                                                       
#    docker exec -u www-data nextcloud php occ --no-warnings config:system:set trusted_domains $TRUSTED_INDEX --value="$NGINX_CONTAINER_NAME"                                                     
#fi                                                                                                                                                                                         
                                                                                                                                                                                           
#rm trusted_domain.tmp

docker exec -u www-data nextcloud php occ --no-warnings app:install onlyoffice

#docker exec -u www-data nextcloud php occ --no-warnings config:system:set onlyoffice DocumentServerUrl --value="/ds-vpath/"
#docker exec -u www-data nextcloud php occ --no-warnings config:system:set onlyoffice DocumentServerInternalUrl --value="http://$ONLYOFFICE_CONTAINER_NAME/"
#docker exec -u www-data nextcloud php occ --no-warnings config:system:set onlyoffice StorageUrl --value="http://$NGINX_CONTAINER_NAME/"
#docker exec -u www-data nextcloud php occ --no-warnings config:system:set onlyoffice jwt_secret --value="$ONLYOFFICE_SECRET"
#docker exec -u www-data nextcloud php occ --no-warnings config:system:set filesystem_check_changes --type=integer --value="1"
#docker exec -u www-data nextcloud php occ --no-warnings config:system:set maintenance_window_start --type=integer --value="1"
#docker exec -u www-data nextcloud php occ --no-warnings config:system:set trusted_domains 2 --value="$TRUSTED_DOMAIN_NAME"

# https://www.allerstorfer.at/nextcloud-install-preview-generator/
docker exec -u www-data nextcloud php occ --no-warnings app:install previewgenerator
#docker exec nextcloud apt install libreoffice libreoffice-l10n-de libreoffice-help-de 
docker exec nextcloud apt install ffmpeg imagemagick ghostscript 

#docker exec -u www-data nextcloud php occ --no-warnings config:system:set 'preview_libreoffice_path' --value='/usr/bin/libreoffice'
docker exec -u www-data nextcloud php occ --no-warnings config:system:set 'enable_previews' --type=bool --value=true
docker exec -u www-data nextcloud php occ --no-warnings config:system:set enabledPreviewProviders 0 --value="OC\\Preview\\TXT"
docker exec -u www-data nextcloud php occ --no-warnings config:system:set enabledPreviewProviders 1 --value="OC\\Preview\\Image"
docker exec -u www-data nextcloud php occ --no-warnings config:system:set enabledPreviewProviders 2 --value="OC\\Preview\\Movie"
docker exec -u www-data nextcloud php occ --no-warnings config:system:set enabledPreviewProviders 3 --value="OC\\Preview\\MP4"
docker exec -u www-data nextcloud php occ --no-warnings config:system:set enabledPreviewProviders 4 --value="OC\\Preview\\GIF"
docker exec -u www-data nextcloud php occ --no-warnings config:system:set enabledPreviewProviders 5 --value="OC\\Preview\\Markdown"
docker exec -u www-data nextcloud php occ --no-warnings config:system:set enabledPreviewProviders 6 --value="OC\\Preview\\OpenDocument"
docker exec -u www-data nextcloud php occ --no-warnings config:system:set enabledPreviewProviders 7 --value="OC\\Preview\\MSOffice2003"
docker exec -u www-data nextcloud php occ --no-warnings config:system:set enabledPreviewProviders 8 --value="OC\\Preview\\MSOfficeDoc"

docker exec -u www-data nextcloud php /var/www/nextcloud/occ preview:generate-all -vvv
(crontab -l ; echo "*/10 * * * * docker exec -u www-data nextcloud php occ preview:pre-generate -vvv") | crontab -

docker exec -u www-data nextcloud php occ --no-warnings app:install memories
#docker exec -u www-data nextcloud php occ --no-warnings app:disable activity 
#docker exec -u www-data nextcloud php occ --no-warnings app:disable photos 
docker exec -u www-data nextcloud php occ --no-warnings app:install calendar  
docker exec -u www-data nextcloud php occ --no-warnings app:install contacts 
#docker exec -u www-data nextcloud php occ --no-warnings app:install deck
#docker exec -u www-data nextcloud php occ --no-warnings app:install notes
docker exec -u www-data nextcloud php occ --no-warnings app:install tasks
docker exec -u www-data nextcloud php occ --no-warnings app:install maps
docker exec -u www-data nextcloud php occ --no-warnings app:install external
#docker exec -u www-data nextcloud php occ --no-warnings app:enable files_external

docker exec -it nextcloud /bin/bash -c "apt update && apt install -y ffmpeg imagemagick ghostscript"

docker exec -u www-data nextcloud php occ files:scan --all -vvv

# if php occ files:scan --all fails
#docker exec -u www-data nextcloud chmod -R 755 /var/www/html/data
#docker exec -u www-data nextcloud chown -R www-data:www-data /var/www/html/data

docker exec -u www-data nextcloud php occ memories:index --user=USERNAME --folder=/path/
docker exec -u www-data nextcloud php occ config:system:set maintenance_window_start --type=integer --value=1
