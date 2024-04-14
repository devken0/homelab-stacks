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


