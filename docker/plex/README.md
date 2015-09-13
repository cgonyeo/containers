The container built by this is available under `dgonyeo/plex` on the docker hub.

To use:
- Copy `plexmediaserver.service` to the `~/.config/systemd/user/` directory
- Modify `~/.config/systemd/user/plexmediaserver.service` to point to
  somewhere that makes sense for your configs and media. (Note: `%h` expands to
  the user's home)
- `systemctl --user daemon-reload`
- `systemctl --user enable plexmediaserver.service`
- `systemctl --user start plexmediaserver.service`

Note that if you want to have your user's `systemd` services start on boot and
persist when there are no sessions for your user active, you'll need to enable
lingering for the user. Details on this are available
[here](https://wiki.archlinux.org/index.php/Systemd/User#Automatic_start-up_of_systemd_user_instances).
For tl;dr, just run the command `loginctl enable-linger <username>`.

