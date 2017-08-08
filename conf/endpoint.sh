#!/bin/sh

if [[ -z "${DEPLOY_ENV}" ]]; then
  C9_EXTRA = ""
fi

export C9_EXTRA
supervisord -c /etc/supervisor/supervisord.conf
