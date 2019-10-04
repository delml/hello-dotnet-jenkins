#!/bin/sh

[ -n "$HELLOMVC_SERVICE_NAME" ] || exit 1

sudo chkconfig --del ${HELLOMVC_SERVICE_NAME}
sudo cp -f ./jenkins/scripts/dotnet_service.sh /etc/init.d/${HELLOMVC_SERVICE_NAME}
sudo chmod +x /etc/init.d/${HELLOMVC_SERVICE_NAME}
sudo chkconfig --add ${HELLOMVC_SERVICE_NAME}
