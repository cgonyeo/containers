#/usr/bin/env bash

echo "executing: rkt run --volume x11socket,kind=host,source=/tmp/.X11-unix --volume dbus,kind=host,source=/etc/machine-id --interactive $@"

rkt run --volume x11socket,kind=host,source=/tmp/.X11-unix --volume dbus,kind=host,source=/etc/machine-id --interactive $@
