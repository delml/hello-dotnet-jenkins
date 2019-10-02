#!/bin/sh

[ -n "$APP_NAME" ] || exit 1
[ -n "$APP_ENVIRONMENT" ] || exit 1
[ -n "$SERVICE_NAME" ] || exit 1

# Directory to create config file in
config_dir=/etc/dotnet

# Generate config file
cat << EOF > service.conf
DOTNET_APP_DLL=/opt/${APP_NAME}/HelloMvc.dll
ASPNETCORE_ENVIRONMENT=${APP_ENVIRONMENT}
EOF

sudo mkdir -p "$config_dir"
sudo mv -f service.conf "${config_dir}/${SERVICE_NAME}.conf"
