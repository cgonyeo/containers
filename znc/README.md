This should be everything needed to reconstruct the znc container available at
`aci.gonyeo.com/znc`.

The `rkt-znc.service` file should be modified for the rkt volume, and then
installed to `/etc/systemd/system/rkt-znc.service`. `systemctl daemon-reload`,
`systemctl status rkt-znc`.

To build:
- Have [acbuild](https://github.com/appc/acbuild) built and in your path
- Optionally modify the `USER` and `GROUP` variables in `build-znc.sh`
- Run `build-znc.sh` as root
