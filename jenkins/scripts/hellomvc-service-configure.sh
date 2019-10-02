#!/bin/sh

[ -n "$SERVICE_NAME" ] || exit 1

sudo chkconfig --del ${SERVICE_NAME}
sudo cp -f ./jenkins/scripts/dotnet_service.sh /etc/init.d/${SERVICE_NAME}
sudo chmod +x /etc/init.d/${SERVICE_NAME}
sudo chkconfig --add ${SERVICE_NAME}
