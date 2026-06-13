#!/bin/sh
# dev-mount.sh — one-shot dev-VM setup. Run via:
#   curl -fsSL https://raw.githubusercontent.com/28allday/nosignal-shell/nosignal/packaging/dev-mount.sh | sudo sh
#
# Mounts the 9p `nsfork` share (the host's nosignal-shell fork) at /mnt/fork and
# points the running shell at it (~/.config/quickshell/caelestia symlink), so
# host-side QML edits + Ctrl+Super+Alt+R preview the layout live.
set -eu

modprobe 9pnet_virtio 2>/dev/null || true
mkdir -p /mnt/fork
if ! mountpoint -q /mnt/fork; then
  mount -t 9p -o trans=virtio,version=9p2000.L,access=any nsfork /mnt/fork
fi
[ -e /mnt/fork/shell.qml ] || { echo "9p share mounted but shell.qml missing — wrong mount_tag?" >&2; exit 1; }

# Symlink as the human user (this script runs as root via sudo).
U="${SUDO_USER:-$(logname 2>/dev/null || true)}"
[ -n "$U" ] || U=$(awk -F: '$3>=1000 && $3<60000 && $7 !~ /(nologin|false)$/ {print $1; exit}' /etc/passwd)
H=$(getent passwd "$U" | cut -d: -f6)
install -d -o "$U" -g "$U" "$H/.config/quickshell"
if [ -e "$H/.config/quickshell/caelestia" ] && [ ! -L "$H/.config/quickshell/caelestia" ]; then
  mv "$H/.config/quickshell/caelestia" "$H/.config/quickshell/caelestia.bak.$$"
fi
sudo -u "$U" ln -sfn /mnt/fork "$H/.config/quickshell/caelestia"

echo ":: fork mounted at /mnt/fork"
echo ":: ~$U/.config/quickshell/caelestia -> /mnt/fork (the host fork checkout)"
echo ":: NOW reload the shell to load the fork:  Ctrl+Super+Alt+R"
