#!/bin/sh

[ -n "$HELLOMVC_PROJECT_NAME" ] || exit 1
[ -n "$HELLOMVC_ENVIRONMENT" ] || exit 1
[ -n "$HELLOMVC_PUBLISH_TO" ] || exit 1

case "$HELLOMVC_ENVIRONMENT" in
  Development|Staging) publish_config=Debug ;;
  *) publish_config=Release ;;
esac

dotnet publish $HELLOMVC_PROJECT_NAME --configuration $publish_config --output $HELLOMVC_PUBLISH_TO
