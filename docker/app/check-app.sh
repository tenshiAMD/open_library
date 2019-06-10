#! /bin/bash

curl -f -u ${HEALTH_CHECK_AUTH} http://localhost:80/health/all || exit 1