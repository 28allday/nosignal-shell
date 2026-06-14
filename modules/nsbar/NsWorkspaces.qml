pragma ComponentBehavior: Bound

// NoSignal workspaces module: numbered 1..N, no capsule. Active = filled accent
// pill with dark (onAccent) text + workspace name (e.g. "2 code"); occupied =
// bright number; empty = faint number. Click switches workspace.

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.services
import qs.components

RowLayout {
    id: root

    spacing: 4

    Repeater {
        model: Config.bar.workspaces.shown

        delegate: Rectangle {
            id: ws

            required property int index
            readonly property int wsId: index + 1
            readonly property var hw: Hypr.workspaces.values.find(w => w.id === wsId) ?? null
            readonly property bool active: Hypr.activeWsId === wsId
            readonly property bool occupied: (hw?.lastIpcObject.windows ?? 0) > 0
            readonly property string wsName: {
                const n = hw?.name ?? "";
                return n && n !== String(wsId) && !n.startsWith("special") ? n : "";
            }

            Layout.alignment: Qt.AlignVCenter
            implicitWidth: row.implicitWidth + (active ? 16 : 10)
            implicitHeight: 22
            radius: Theme.radius.barModule
            color: active ? Theme.accent : mouse.containsMouse ? Theme.hover : "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: Theme.hoverMs
                }
            }
            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 120
                    easing.type: Easing.OutCubic
                }
            }

            RowLayout {
                id: row

                anchors.centerIn: parent
                spacing: 5

                StyledText {
                    text: ws.wsId
                    color: ws.active ? Theme.onAccent : ws.occupied ? Theme.text : Theme.textFaint
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.bar
                    font.weight: ws.active ? Font.DemiBold : Font.Normal
                }

                StyledText {
                    visible: ws.active && ws.wsName !== ""
                    text: ws.wsName
                    color: Theme.onAccent
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.bar
                }
            }

            MouseArea {
                id: mouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Hypr.dispatch(`workspace ${ws.wsId}`)
            }
        }
    }
}
