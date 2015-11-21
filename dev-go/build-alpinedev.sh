#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

# Start the build with an empty ACI
acbuild --debug begin

# In the event of the script exiting, end the build
acbuildEnd() {
    export EXIT=$?
    acbuild --debug end && exit $EXIT 
}
trap acbuildEnd EXIT

acbuild --debug dep add aci.gonyeo.com/alpine

acbuild --debug run -- apk update
acbuild --debug run -- apk add go vim git gcc bash musl-dev linux-headers rsync zsh less tar openssh perl
acbuild --debug run -- /bin/sh -c 'CGO_ENABLED=0 go install -a -installsuffix cgo std'

#acbuild --debug run -- addgroup -g 100 users
acbuild --debug run -- adduser -D -u 1000 -h /home/derek -s /bin/zsh derek users

acbuild --debug run -- su derek -c 'git clone https://github.com/dgonyeo/dotfiles.git /home/derek/dotfiles'
acbuild --debug run -- su derek -c 'cd /home/derek/dotfiles && ./install.sh'

acbuild --debug set-exec -- /bin/zsh

acbuild --debug set-user 1000
acbuild --debug set-group 100

acbuild --debug set-name aci.gonyeo.com/dev-go

acbuild --debug env add HOME /home/derek

acbuild --debug mount add go /go

acbuild --debug env add GOPATH /go
acbuild --debug env add TERM xterm

acbuild --debug write --overwrite dev-go-linux-latest-amd64.aci
