#!/bin/sh

[ -n "$HELLOMVC_APP_NAME" ] || exit 1
[ -n "$HELLOMVC_APP_ENVIRONMENT" ] || exit 1
[ -n "$HELLOMVC_SERVICE_NAME" ] || exit 1

# Directory to create config file in
config_dir=/etc/dotnet

# Generate config file
cat << EOF > service.conf
DOTNET_APP_DLL=/opt/${HELLOMVC_APP_NAME}/HelloMvc.dll
ASPNETCORE_ENVIRONMENT=${HELLOMVC_APP_ENVIRONMENT}
EOF

sudo mkdir -p "$config_dir"
sudo mv -f service.conf "${config_dir}/${HELLOMVC_SERVICE_NAME}.conf"
