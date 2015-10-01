# Begin the build
acbuild begin

# Name the aci
acbuild name aci.gonyeo.com/plex

acbuild dependency add aci.gonyeo.com/ubuntu

# Download and install plex
acbuild exec -- apt-get update
acbuild exec -- apt-get install -y wget
acbuild exec -- wget https://downloads.plex.tv/plex-media-server/0.9.12.11.1406-8403350/plexmediaserver_0.9.12.11.1406-8403350_amd64.deb
acbuild exec -- dpkg -i plexmediaserver_0.9.12.11.1406-8403350_amd64.deb
acbuild exec -- rm plexmediaserver_0.9.12.11.1406-8403350_amd64.deb
acbuild exec -- rm -f ./rootfs/var/cache/apt/archives/*.deb ./rootfs/var/cache/apt/archives/partial/*.deb ./rootfs/var/cache/apt/*.bin

# Set environment variables for plex
acbuild environment add PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR "/var/lib/plexmediaserver/Library/Application Support"
acbuild environment add PLEX_MEDIA_SERVER_HOME /usr/lib/plexmediaserver
acbuild environment add PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS 6
acbuild environment add PLEX_MEDIA_SERVER_TMPDIR /tmp
acbuild environment add LD_LIBRARY_PATH /usr/lib/plexmediaserver
acbuild environment add LC_ALL en_US.UTF-8
acbuild environment add LANG en_US.UTF-8

# Set plex to be the run command
acbuild set-run "/usr/lib/plexmediaserver/Plex Media Server"

# Add mount points for configs and media
acbuild mount add config "/var/lib/plexmediaserver/Library/Application Support"
acbuild mount add media /media --read-only

# Finish the build
acbuild end --overwrite plex.aci
