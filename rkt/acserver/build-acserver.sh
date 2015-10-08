go get -d github.com/appc/acserver

goaci go github.com/appc/acserver

acbuild --debug begin acserver.aci
acbuild --debug copy $GOPATH/src/github.com/appc/acserver/templates .
acbuild --debug mount add acis /acis
acbuild --debug set-exec "/acserver"
acbuild --debug set-name "aci.gonyeo.com/acserver"
acbuild --debug end --overwrite acserver.aci
