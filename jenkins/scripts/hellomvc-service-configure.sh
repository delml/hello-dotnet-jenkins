#!/bin/sh

[ -n "$HELLOMVC_IDENTIFIER" ] || exit 1

systemd=/usr/lib/systemd/system
unit_file=$HELLOMVC_IDENTIFIER.service

# Source Mustache
. jenkins/scripts/lib/mo.bash

echo 'Generating SystemD unit file...'
mo --fail-not-set -- 'jenkins/config/hellomvc.service.mustache' > "$unit_file"

echo 'Registering service with systemctl...'
sudo cp "$unit_file" "$systemd"
sudo systemctl enable "$unit_file"

echo 'Reloading/restarting service...'
sudo systemctl reload-or-restart "$unit_file"
