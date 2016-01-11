#!/usr/bin/env bash

# Exit if an error occurs
set -e

# Function to call for cleanup
acbuildend () { export EXT=$?; acbuild --debug end && exit $EXT; }

# Begin a new build
acbuild --debug begin

# When the script exits, call cleanup
trap acbuildend EXIT

# Add a dependency on the nginx image
acbuild --debug dep add aci.gonyeo.com/nginx

# Copy the site to nginx's serve location
acbuild --debug copy $1 /usr/share/nginx/html

# Add a port for the site to be hosted over
acbuild --debug port add http tcp 80

# Set the name of the image
acbuild --debug set-name "aci.gonyeo.com/blog"

# Exec nginx in the foreground
acbuild --debug set-exec -- "/usr/sbin/nginx" "-g" "daemon off;"

# Write the image
acbuild --debug write --overwrite blog-latest-linux-amd64.aci
