pragma ComponentBehavior: Bound

// NoSignal toggle switch (animated 16px knob) used in panel headers.

import QtQuick
import qs.services

Rectangle {
    id: root

    property bool on: false
    signal toggled

    implicitWidth: 38
    implicitHeight: 22
    radius: 11
    color: on ? Theme.accent : Theme.fillSubtle

    Behavior on color {
        ColorAnimation {
            duration: Theme.hoverMs
        }
    }

    Rectangle {
        x: root.on ? parent.width - width - 3 : 3
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: 16
        implicitHeight: 16
        radius: 8
        color: root.on ? Theme.onAccent : Theme.text

        Behavior on x {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.toggled()
    }
}
