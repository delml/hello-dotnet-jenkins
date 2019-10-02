#!/bin/sh

[ -n "$APP_NAME" ] || exit 1
[ -n "$APP_ENVIRONMENT" ] || exit 1
[ -n "$ASPNETCORE_TARGET_FRAMEWORK" ] || exit 1

case "$APP_ENVIRONMENT" in
  Development|Staging) publish_config=Debug ;;
  *) publish_config=Release ;;
esac

publish_orig=./HelloMvc/bin/$publish_config/$ASPNETCORE_TARGET_FRAMEWORK/publish
publish_dir=/opt
publish_dest=$publish_dir/${APP_NAME}

dotnet publish HelloMvc --configuration $publish_config
sudo mkdir -p "$publish_dir"
sudo rm -fr "$publish_dest"
sudo mv "$publish_orig" "$publish_dest"
