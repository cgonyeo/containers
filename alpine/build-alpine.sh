#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

acbuildend () {
    export EXT=$?;
    acbuild --debug end && exit $EXT;
}

acbuild --debug begin quay.io/coreos/alpine-sh
trap acbuildend EXIT

acbuild --debug set-name aci.gonyeo.com/alpine

acbuild --debug run -- /bin/sh -c 'chmod 755 /'

acbuild --debug copy resolv.conf /etc/resolv.conf

acbuild --debug write --overwrite alpine.aci
