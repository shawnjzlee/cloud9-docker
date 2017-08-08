#!/bin/bash

if [[ -z "${C9_EXTRA}" ]]; then
  C9_EXTRA=""
fi

export C9_EXTRA
supervisord -c /etc/supervisor/supervisord.conf
