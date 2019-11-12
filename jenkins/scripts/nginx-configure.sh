#!/usr/bin/bash

[ -n "$HELLOMVC_ENVIRONMENT" ] || exit 1

case "$HELLOMVC_ENVIRONMENT" in
  Staging) file_suffix=-staging ;;
  *) unset file_suffix ;;
esac

sudo cp "config/nginx/hellomvc${file_suffix}.conf" '/etc/nginx/conf.d/'

sudo nginx -s reload
