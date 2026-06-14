pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia.Config
import qs.components.containers
import qs.modules.bar as Bar

Scope {
    id: root

    required property ShellScreen screen
    required property Bar.BarWrapper bar

    ExclusionZone {
        anchors.left: true
    }

    ExclusionZone {
        anchors.top: true
        exclusiveZone: 0 // NoSignal: NsBar owns the top exclusive zone
    }

    ExclusionZone {
        anchors.right: true
    }

    ExclusionZone {
        anchors.bottom: true
    }

    component ExclusionZone: StyledWindow {
        screen: root.screen
        name: "border-exclusion"
        exclusiveZone: 0 // NoSignal: no screen-edge frame
        mask: Region {}
        implicitWidth: 1
        implicitHeight: 1
    }
}
