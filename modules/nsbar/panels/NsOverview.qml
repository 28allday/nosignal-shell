pragma ComponentBehavior: Bound

// NoSignal Workspaces overview (off the window-title module). Row of workspace
// thumbnails (active = accent border + glow), number + name below, click to
// switch. Wired to Hypr.

import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.services
import qs.components

NsPanel {
    id: root

    implicitWidth: 5 * 124 + 16 * 2 + Theme.size.panelPad * 2 - 16
    anchorMode: "center"

    readonly property int shown: Config.bar.workspaces.shown

    RowLayout {
        Layout.fillWidth: true

        StyledText {
            text: "Workspaces"
            color: Theme.text
            font.family: Theme.font.family
            font.pixelSize: Theme.font.panelTitle
            font.weight: Font.DemiBold
        }

        Item {
            Layout.fillWidth: true
        }

        StyledText {
            text: root.shown + " desktops"
            color: Theme.textFaint
            font.family: Theme.font.family
            font.pixelSize: Theme.font.bodySmall
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 16

        Repeater {
            model: root.shown

            delegate: ColumnLayout {
                id: cell

                required property int index
                readonly property int wsId: index + 1
                readonly property var hw: Hypr.workspaces.values.find(w => w.id === wsId) ?? null
                readonly property bool active: Hypr.activeWsId === wsId
                readonly property bool occupied: (hw?.lastIpcObject.windows ?? 0) > 0
                readonly property string wsName: {
                    const n = hw?.name ?? "";
                    return n && n !== String(wsId) && !n.startsWith("special") ? n : "";
                }

                spacing: 6

                Rectangle {
                    implicitWidth: 108
                    implicitHeight: 68 // 16:10-ish
                    radius: Theme.radius.tile
                    color: Qt.rgba(0, 0, 0, cell.occupied ? 0.35 : 0.5)
                    border.width: cell.active ? 2 : 1
                    border.color: cell.active ? Theme.accent : Theme.panelBorder

                    NsIcon {
                        anchors.centerIn: parent
                        visible: cell.occupied
                        icon: "web_asset"
                        color: Theme.textFaint
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Hypr.dispatch(`workspace ${cell.wsId}`);
                            NsShell.close();
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 5

                    StyledText {
                        text: cell.wsId
                        color: cell.active ? Theme.accent : Theme.textMuted
                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.bodySmall
                        font.weight: cell.active ? Font.DemiBold : Font.Normal
                    }
                    StyledText {
                        visible: cell.wsName !== ""
                        text: cell.wsName
                        color: cell.active ? Theme.accent : Theme.textMuted
                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.bodySmall
                    }
                }
            }
        }
    }
}
