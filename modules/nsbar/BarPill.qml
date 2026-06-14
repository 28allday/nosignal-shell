pragma ComponentBehavior: Bound

// NoSignal bar module pill: hover-highlightable (radius 5, hover bg); when its
// panel is open it uses accent.soft bg + accent foreground. Children go in a
// centered Row. `active` drives the open/highlight state; `triggered()` fires on
// click (the bar wires this to toggle its openPanel string).

import QtQuick
import qs.services

Rectangle {
    id: root

    property bool active: false
    property int hPad: 9
    signal triggered

    default property alias content: inner.data

    implicitWidth: inner.implicitWidth + hPad * 2
    implicitHeight: 26
    radius: Theme.radius.barModule
    color: active ? Theme.accentSoft : mouse.containsMouse ? Theme.hover : "transparent"

    Behavior on color {
        ColorAnimation {
            duration: Theme.hoverMs
        }
    }

    Row {
        id: inner

        anchors.centerIn: parent
        spacing: 6
    }

    MouseArea {
        id: mouse

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.triggered()
    }
}
