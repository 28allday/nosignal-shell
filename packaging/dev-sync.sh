#!/bin/sh
# dev-sync.sh — background loop for the live VM preview. Copies the fork's QML
# from the 9p mount (/mnt/fork) into the LOCAL quickshell config so quickshell's
# file-watcher (settings.watchFiles) auto-reloads on host-side edits. 9p doesn't
# propagate inotify, so we poll + copy to a local dir where inotify works.
#
# Run once in the VM (after dev-mount.sh has set up the local config copy):
#   setsid sh /mnt/fork/packaging/dev-sync.sh >/dev/null 2>&1 &
#
# Then just edit the fork on the HOST — the VM shell reloads within ~2s.
set -eu
SRC=/mnt/fork
DST="$HOME/.config/quickshell/caelestia"

[ -e "$SRC/shell.qml" ] || { echo "9p fork not mounted at $SRC" >&2; exit 1; }
[ -d "$DST" ] || { echo "$DST is not a local dir — run dev-mount.sh's local-copy step first" >&2; exit 1; }

while true; do
  for d in shell.qml modules components services utils assets; do
    [ -e "$SRC/$d" ] && cp -ru "$SRC/$d" "$DST/" 2>/dev/null || true
  done
  sleep 1.5
done
