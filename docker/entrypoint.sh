#! /bin/bash

liquid /etc/nginx/nginx.liquid /etc/nginx/nginx.conf

if [[ -f "${APP_HOME}/config/credentials/${RAILS_ENV}.yml.enc" ]]; then
    cp ${APP_HOME}/config/credentials/${RAILS_ENV}.yml.enc ${APP_HOME}/config/credentials.yml.enc
fi

exec "$@"
