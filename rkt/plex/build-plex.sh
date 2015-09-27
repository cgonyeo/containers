set -e

# Won't be necessary once dependencies are properly working
wget -nc aci.gonyeo.com/ubuntu-latest-linux-amd64.aci

# Begin the build
acbuild --debug init ubuntu-latest-linux-amd64.aci

# Name the aci
acbuild --debug name aci.gonyeo.com/plex

# Download and install plex
acbuild --debug exec -- /usr/bin/apt-get update
acbuild --debug exec -- /usr/bin/apt-get install -y wget
acbuild --debug exec -- /usr/bin/wget https://downloads.plex.tv/plex-media-server/0.9.12.11.1406-8403350/plexmediaserver_0.9.12.11.1406-8403350_amd64.deb
acbuild --debug exec -- /usr/bin/dpkg -i plexmediaserver_0.9.12.11.1406-8403350_amd64.deb
acbuild --debug exec -- /bin/rm plexmediaserver_0.9.12.11.1406-8403350_amd64.deb
acbuild --debug exec -- /bin/rm -f ./rootfs/var/cache/apt/archives/*.deb ./rootfs/var/cache/apt/archives/partial/*.deb ./rootfs/var/cache/apt/*.bin

# Set environment variables for plex
acbuild --debug add-env PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR "/var/lib/plexmediaserver/Library/Application Support"
acbuild --debug add-env PLEX_MEDIA_SERVER_HOME /usr/lib/plexmediaserver
acbuild --debug add-env PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS 6
acbuild --debug add-env PLEX_MEDIA_SERVER_TMPDIR /tmp
acbuild --debug add-env LD_LIBRARY_PATH /usr/lib/plexmediaserver
acbuild --debug add-env LC_ALL en_US.UTF-8
acbuild --debug add-env LANG en_US.UTF-8

# Set plex to be the run command
acbuild --debug set-run "/usr/lib/plexmediaserver/Plex Media Server"

# Add mount points for configs and media
acbuild --debug add-mount config "/var/lib/plexmediaserver/Library/Application Support"
acbuild --debug add-mount media /media --read-only

# Finish the build
acbuild --debug finish --overwrite plex.aci
