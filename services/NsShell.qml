pragma Singleton
pragma ComponentBehavior: Bound

// NoSignal shell-level popup state. "One panel open at a time" — `open` is the
// id of the active panel ("" = none). `anchorX` is the scene x of the trigger
// (a bar pill) center, used to position under-trigger / right-anchored popups.
// The NsBar pills call toggle(); the NsOverlay reads `open` and renders the panel.

import QtQuick
import Quickshell

Singleton {
    id: root

    property string open: ""
    property real anchorX: 0

    function toggle(id: string, x: real): void {
        if (root.open === id) {
            root.open = "";
        } else {
            root.open = id;
            root.anchorX = x;
        }
    }

    function show(id: string, x: real): void {
        root.open = id;
        root.anchorX = x;
    }

    function close(): void {
        root.open = "";
    }
}
