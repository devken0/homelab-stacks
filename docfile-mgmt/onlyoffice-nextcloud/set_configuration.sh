#!/bin/bash

set -x

docker exec -u www-data nextcloud php occ --no-warnings config:system:get trusted_domains >> trusted_domain.tmp

if ! grep -q "nextcloud-proxy" trusted_domain.tmp; then
    TRUSTED_INDEX=$(cat trusted_domain.tmp | wc -l);
    docker exec -u www-data nextcloud php occ --no-warnings config:system:set trusted_domains $TRUSTED_INDEX --value="nextcloud-proxy"
fi

rm trusted_domain.tmp

docker exec -u www-data nextcloud php occ --no-warnings app:install onlyoffice

docker exec -u www-data nextcloud php occ --no-warnings config:system:set onlyoffice DocumentServerUrl --value="/ds-vpath/"
docker exec -u www-data nextcloud php occ --no-warnings config:system:set onlyoffice DocumentServerInternalUrl --value="http://onlyoffice-docs/"
docker exec -u www-data nextcloud php occ --no-warnings config:system:set onlyoffice StorageUrl --value="http://nextcloud-proxy/"
docker exec -u www-data nextcloud php occ --no-warnings config:system:set onlyoffice jwt_secret --value="elaborate-catwalk-onlyoffice-secret"
docker exec -u www-data nextcloud php occ --no-warnings config:system:set filesystem_check_changes --value="1"
