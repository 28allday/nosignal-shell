pragma Singleton
pragma ComponentBehavior: Bound

// NoSignal shell-level popup state. "One panel open at a time" — `open` is the
// id of the active panel ("" = none). `anchorX` is the scene x of the trigger
// (a bar pill) center, used to position under-trigger / right-anchored popups.
// `screen` is the name of the output that owns the open panel, so a per-screen
// NsOverlay shows it on ONLY that monitor instead of mirroring on all of them
// (multi-monitor fix, 2026-06-20). "" = no owner → show on all screens (used by
// the full-screen power modal opened from a global keybind, which has no screen).
// The NsBar pills call toggle() with their screen; NsOverlay matches on `screen`.

import QtQuick
import Quickshell

Singleton {
    id: root

    property string open: ""
    property real anchorX: 0
    property string screen: ""

    function toggle(id: string, x: real, screen: string): void {
        const scr = screen ?? "";
        if (root.open === id && root.screen === scr) {
            root.open = "";
        } else {
            root.open = id;
            root.anchorX = x;
            root.screen = scr;
        }
    }

    function show(id: string, x: real, screen: string): void {
        root.open = id;
        root.anchorX = x;
        root.screen = screen ?? "";
    }

    function close(): void {
        root.open = "";
    }
}
