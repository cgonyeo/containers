FROM centos

RUN yum install -y wget

RUN wget https://downloads.plex.tv/plex-media-server/0.9.12.11.1406-8403350/plexmediaserver-0.9.12.11.1406-8403350.x86_64.rpm

RUN yum install -y ple*

RUN rm ple*

VOLUME /media

# The following taken from the systemd service file in the rpm
Env PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR "/var/lib/plexmediaserver/Library/Application Support"
Env PLEX_MEDIA_SERVER_HOME /usr/lib/plexmediaserver
Env PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS 6
Env PLEX_MEDIA_SERVER_TMPDIR /tmp
Env LD_LIBRARY_PATH /usr/lib/plexmediaserver
Env LC_ALL en_US.UTF-8
Env LANG en_US.UTF-8

RUN /bin/sh -c '/usr/bin/test -d "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}" || /bin/mkdir -p "${PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR}"'

CMD /usr/lib/plexmediaserver/Plex\ Media\ Server
