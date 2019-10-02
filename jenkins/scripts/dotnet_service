#!/bin/sh
#
# Based on nginx's script.
#
# dotnet - this script starts and stops the dotnet daemon
#
# chkconfig:   35 86 15
# description: .NET Core application
# processname: dotnet
# config:      /etc/dotnet/{SERVICE_NAME}.conf
# pidfile:     /var/run/{SERVICE_NAME}.pid

# Source function library.
. /etc/rc.d/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

# Check that networking is up.
[ "$NETWORKING" = "no" ] && exit 0

dotnet="/usr/bin/dotnet"
app=$(basename $(readlink $0))

lockfile="/var/lock/subsys/$app"
pidfile="/var/run/${app}.pid"
config="/etc/dotnet/${app}.conf"

DOTNET_APP_DLL=
DOTNET_APP_ARGS=

[ -f $config ] && . $config


start() {
    [ -x $dotnet ] || exit 5
    [ -n "$DOTNET_APP_DLL" ] || exit 6
    echo -n $"Starting $app: "
    daemon $dotnet $DOTNET_APP_DLL $DOTNET_APP_ARGS
    retval=$?
    echo
    [ $retval -eq 0 ] && touch $lockfile
    return $retval
}

stop() {
    echo -n $"Stopping $app: "
    killproc -p $pidfile $app
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    stop
    start
}

rh_status() {
    status $app
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}

case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    status|status_q)
        rh_$1
        ;;
    condrestart|try-restart)
        rh_status_q || exit 7
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart}"
        exit 2
esac
