This should be everything needed to reconstruct the znc container available at
`aci.gonyeo.com/znc`.

The `rkt-znc.service` file should be modified for the rkt volume, and then
installed to `/etc/systemd/system/rkt-znc.service`. `systemctl daemon-reload`,
`systemctl status rkt-znc`.

To build:
- `git clone git://git.buildroot.net/buildroot` (More info on buildroot
  available [here](http://buildroot.org/))
- `cp buildroot.config buildroot/.config`
- `cd buildroot`
- `make`
- `cd ..`
- `mkdir znc`
- `mv buildroot/output/target znc/rootfs`
- `echo "nameserver 8.8.8.8" > znc/rootfs/etc/resolv.conf`
- `cp manifest znc/`
- `actool build znc znc.aci`
