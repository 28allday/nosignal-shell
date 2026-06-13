# nosignal-shell — dev notes

NoSignal's fork of `caelestia-dots/shell`. We build this (package `nosignal-shell`,
`provides`/`conflicts` `caelestia-shell`) instead of the AUR `caelestia-shell`, so
the interface/layout is ours and pinned — `pacman -Syu`/`yay` never overwrites it.

- **Branch:** `nosignal` (cut off the `v2.0.2` tag). `main` tracks upstream
  (`git remote -v` → `upstream` = caelestia-dots/shell). Merge upstream into
  `nosignal` deliberately when wanted.
- **Install path:** `/etc/xdg/quickshell/caelestia/` (namespace stays `caelestia`
  so caelestia-cli + hypr binds + `~/.config/caelestia/` keep working).
- **Shipping work:** commit to `nosignal`, then bump `NOSIGNAL_SHELL_COMMIT` in
  the NoSignal builder (`~/Projects/nosignal/nosignal.sh`) to the new tip + rebuild.

## Live preview loop (edit on host → reload in a VM)
From the NoSignal builder repo: `./vm/run-dev.sh` (boots the installed disk with
this checkout shared over 9p). In the VM terminal (Super+Return):

```
curl -fsSL https://raw.githubusercontent.com/28allday/nosignal-shell/nosignal/packaging/dev-mount.sh -o /tmp/d.sh && sudo sh /tmp/d.sh
setsid sh /mnt/fork/packaging/dev-sync.sh >/dev/null 2>&1 &
pkill -9 quickshell; sleep 2; caelestia shell -d
```

Then edit `.qml` here on the host — the VM shell auto-reloads in ~2-6s.
(`dev-mount.sh` links the shell at a local copy of the fork; `dev-sync.sh` polls
the 9p mount into that local copy so quickshell's file-watcher fires — 9p itself
doesn't propagate inotify.)

## Layout map
`modules/bar/` (bar) · `modules/dashboard/` · `modules/sidebar/` ·
`modules/launcher/` · `modules/session/` · `modules/drawers/` (slide-in panels) ·
`modules/lock/` · `modules/nexus/pages/` (Settings) · `modules/notifications/` ·
`modules/osd/`. Entry point: `shell.qml`. The compiled engine is `plugin/` (C++).
