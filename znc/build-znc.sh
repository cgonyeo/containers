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
acbuild --debug set-name aci.gonyeo.com/znc

# Based on alpine
acbuild --debug dep add aci.gonyeo.com/alpine

# Install znc
acbuild --debug run -- apk update
acbuild --debug run -- apk add znc
acbuild --debug run -- adduser -h /home/zncuser -D -u 1111 zncuser

# Run znc in the foreground
acbuild --debug set-exec -- /usr/bin/znc --foreground

# Add a new user, set the app to run as the new user
acbuild --debug set-user 1111
acbuild --debug set-group 1111

# Add a mount point for znc's config
acbuild --debug mount add configs /home/zncuser/.znc

# Save the ACI
acbuild --debug write --overwrite znc-latest-linux-amd64.aci
