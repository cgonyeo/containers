#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

acbuildend () { export EXT=$?; acbuild --debug end && exit $EXT; }

# Start the build with an empty ACI
acbuild --debug begin

# In the event of the script exiting, end the build
trap acbuildend EXIT

# Name the ACI
acbuild --debug set-name aci.gonyeo.com/debian-x

# Based on alpine
acbuild --debug dep add aci.gonyeo.com/debian

acbuild --debug environment add DISPLAY unix$DISPLAY
acbuild --debug environment add TERM xterm
acbuild mount add x11socket /tmp/.X11-unix
acbuild mount add dbus /etc/machine-id

acbuild --debug set-exec -- /bin/bash

# Save the ACI
acbuild --debug write --overwrite debian-x-latest-linux-amd64.aci
