#!/bin/sh
# dev-setup.sh — run INSIDE the NoSignal dev VM to point the running shell at
# this fork checkout (shared in over 9p), so host-side QML edits preview live.
#
# Prereq (run once per boot, needs root for the 9p mount):
#   sudo mkdir -p /mnt/fork
#   sudo mount -t 9p -o trans=virtio,version=9p2000.L,access=any nsfork /mnt/fork
#
# Then:  sh /mnt/fork/packaging/dev-setup.sh   (then Ctrl+Super+Alt+R to load it)
#
# Quickshell resolves `-c caelestia` from ~/.config/quickshell/caelestia BEFORE
# /etc/xdg/quickshell/caelestia, so this symlink makes the session shell read
# the fork. The compiled Caelestia plugin still comes from the installed package
# (Qt qml import path), so only the layout QML is sourced from the fork.
set -eu
MNT=${MNT:-/mnt/fork}

if [ ! -e "$MNT/shell.qml" ]; then
  echo "fork not mounted at $MNT/shell.qml — mount the 9p share first:" >&2
  echo "  sudo mkdir -p $MNT && sudo mount -t 9p -o trans=virtio,version=9p2000.L,access=any nsfork $MNT" >&2
  exit 1
fi

mkdir -p "$HOME/.config/quickshell"
# Back up any existing real dir/symlink once.
if [ -e "$HOME/.config/quickshell/caelestia" ] && [ ! -L "$HOME/.config/quickshell/caelestia" ]; then
  mv "$HOME/.config/quickshell/caelestia" "$HOME/.config/quickshell/caelestia.bak.$$"
fi
ln -sfn "$MNT" "$HOME/.config/quickshell/caelestia"
echo ":: ~/.config/quickshell/caelestia -> $MNT  (the fork)"
echo ":: now reload the shell to load the fork: press Ctrl+Super+Alt+R"
echo "::   (after each host-side edit, reload again to preview — 9p doesn't"
echo "::    auto-fire the file watcher, so the reload is manual.)"
echo ""
echo ":: to revert to the installed shell:  rm ~/.config/quickshell/caelestia  + reload"
