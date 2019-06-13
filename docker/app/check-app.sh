#! /bin/bash

if [[ -z "${HEALTH_CHECK_AUTH}" ]]; then
  curl -f -u ${HEALTH_CHECK_AUTH} http://localhost:80/health/all || exit 1
else
  exit 0
fi
