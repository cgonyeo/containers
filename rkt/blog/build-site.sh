#!/bin/bash
set -e

acbuild --debug begin

trap "acbuild --debug abort" EXIT

acbuild --debug dep add aci.gonyeo.com/nginx
acbuild --debug copy git/blog/_site /usr/html
acbuild --debug port add http tcp 80
acbuild --debug set-name "aci.gonyeo.com/blog"
acbuild --debug set-exec -- "/usr/sbin/nginx" "-g" "daemon off;"
acbuild --debug end --sign --user derek blog.aci

trap - EXIT
