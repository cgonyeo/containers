#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

delrpm () { rm -rf plex.rpm; }
acbuildend () { delrpm; export EXT=$?; acbuild --debug end && exit $EXT; }

trap delrpm EXIT
curl -o plex.rpm `./latestplex`

acbuild --debug begin
trap acbuildend EXIT

acbuild --debug set-name "aci.gonyeo.com/plex"

acbuild --debug dependency add aci.gonyeo.com/centos

acbuild --debug copy plex.rpm /root/plex.rpm

acbuild --debug run -- /bin/sh -c '(yum install -y /root/plex.rpm || rpm --rebuilddb)'
acbuild --debug run -- rm /root/plex.rpm

# Set environment variables for plex
acbuild --debug environment add PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR "/var/lib/plexmediaserver/Library/Application Support"
acbuild --debug environment add PLEX_MEDIA_SERVER_HOME /usr/lib/plexmediaserver
acbuild --debug environment add PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS 6
acbuild --debug environment add PLEX_MEDIA_SERVER_TMPDIR /tmp
acbuild --debug environment add LD_LIBRARY_PATH /usr/lib/plexmediaserver
acbuild --debug environment add LC_ALL en_US.UTF-8
acbuild --debug environment add LANG en_US.UTF-8

# Set plex to be the run command
acbuild --debug set-exec "/usr/lib/plexmediaserver/Plex Media Server"
acbuild --debug set-event-handler post-stop -- "/bin/rm" "-rf" "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/plexmediaserver.pid"

# Add mount points for configs and media
acbuild --debug mount add config "/var/lib/plexmediaserver/Library/Application Support"
acbuild --debug mount add media /media --read-only

# Add a port for plex traffic
acbuild --debug port add https tcp 32400

# Finish the build
acbuild --debug write --overwrite plex.aci
