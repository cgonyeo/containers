#!/bin/bash
set -e

acbuild --debug begin

trap "{ export EXT=$?; acbuild --debug end && exit $EXT; }" EXIT

acbuild --debug dep add aci.gonyeo.com/nginx
acbuild --debug copy _site /usr/html
acbuild --debug port add http tcp 80
acbuild --debug set-name "aci.gonyeo.com/blog"
acbuild --debug set-exec -- "/usr/sbin/nginx" "-g" "daemon off;"
acbuild --debug write --sign blog.aci