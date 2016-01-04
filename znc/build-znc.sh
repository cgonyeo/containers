#!/usr/bin/env bash
set -e

USER=1000
GROUP=1000

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
acbuild --debug run -- apk add znc znc-extra znc-dev ca-certificates g++ openssl-dev openssl curl

# Add the znc home directory
acbuild --debug run -- mkdir -p /home/zncuser

# Pull down znc-push, build it, install it, perform cleanup
git clone https://github.com/jreese/znc-push.git
acbuild --debug copy znc-push /root/znc-push
rm -rf znc-push
acbuild --debug run -- znc-buildmod /root/znc-push/push.cpp
acbuild --debug run -- mv push.so /usr/lib/znc/push.so
acbuild --debug run -- rm -rf /root/znc-push

# Set the right user perms on the znc home directory
acbuild --debug run -- chown -R $USER:$GROUP /home/zncuser

# Install the hackint ssl cert
acbuild --debug run -- curl -o /root/hackint.crt https://www.hackint.org/crt/rootca.crt
acbuild --debug run -- /bin/sh -c 'ln -s /root/hackint.crt $(openssl x509 -noout -in  /root/hackint.crt -hash)'

# Remove packages that were only needed for building modules
acbuild --debug run -- apk del znc-dev g++ openssl-dev openssl curl

# Run znc in the foreground
acbuild --debug set-exec -- /usr/bin/znc --foreground

# Add a new user, set the app to run as the new user
acbuild --debug set-user $USER
acbuild --debug set-group $GROUP
acbuild --debug environment add HOME /home/zncuser

# Add a mount point for znc's config
acbuild --debug mount add configs /home/zncuser/.znc

# Save the ACI
acbuild --debug write --overwrite znc-latest-linux-amd64.aci
