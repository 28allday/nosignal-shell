pragma ComponentBehavior: Bound

// NoSignal Bluetooth popout (off the BT pill). Title + switch; device rows (icon
// tile peach-tinted if connected, name, status, battery %). Footer "Bluetooth
// settings". Wired to Quickshell.Bluetooth (BlueZ).

import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import qs.services
import qs.utils
import qs.components

NsPanel {
    id: root

    implicitWidth: 340
    anchorMode: "right"

    readonly property var adapter: Bluetooth.defaultAdapter

    RowLayout {
        Layout.fillWidth: true

        StyledText {
            text: "Bluetooth"
            color: Theme.text
            font.family: Theme.font.family
            font.pixelSize: Theme.font.panelTitle
            font.weight: Font.DemiBold
        }

        Item {
            Layout.fillWidth: true
        }

        NsSwitch {
            on: root.adapter?.enabled ?? false
            onToggled: if (root.adapter)
                root.adapter.enabled = !root.adapter.enabled
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        visible: root.adapter?.enabled ?? false

        Repeater {
            model: Bluetooth.devices

            delegate: Rectangle {
                id: row

                required property BluetoothDevice modelData
                readonly property bool connected: modelData?.connected ?? false

                Layout.fillWidth: true
                implicitHeight: 44
                radius: Theme.radius.button
                color: ma.containsMouse ? Theme.hover : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 10

                    Rectangle {
                        implicitWidth: 30
                        implicitHeight: 30
                        radius: 0
                        color: row.connected ? Theme.accentSoft : Theme.fillSubtle

                        NsIcon {
                            anchors.centerIn: parent
                            icon: Icons.getBluetoothIcon(row.modelData?.icon ?? "")
                            color: row.connected ? Theme.accent : Theme.text
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        StyledText {
                            text: row.modelData?.name ?? "?"
                            color: Theme.text
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            font.family: Theme.font.family
                            font.pixelSize: Theme.font.bodySmall
                        }
                        StyledText {
                            text: row.connected ? "Connected" : (row.modelData?.paired ?? false) ? "Paired" : "Not connected"
                            color: row.connected ? Theme.accent : Theme.textMuted
                            font.family: Theme.font.family
                            font.pixelSize: Theme.font.meta
                        }
                    }

                    StyledText {
                        visible: row.connected && (row.modelData?.battery ?? 0) > 0
                        text: Math.round((row.modelData?.battery ?? 0) * 100) + "%"
                        color: Theme.textMuted
                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.meta
                    }
                }

                MouseArea {
                    id: ma
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }

        StyledText {
            visible: Bluetooth.devices.values.length === 0
            text: "No devices"
            color: Theme.textMuted
            font.family: Theme.font.family
            font.pixelSize: Theme.font.bodySmall
        }
    }

    StyledText {
        visible: !(root.adapter?.enabled ?? false)
        text: "Bluetooth is off"
        color: Theme.textMuted
        font.family: Theme.font.family
        font.pixelSize: Theme.font.bodySmall
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 4
        implicitHeight: 1
        color: Theme.barBorder
    }

    StyledText {
        text: "Bluetooth settings"
        color: Theme.textMuted
        font.family: Theme.font.family
        font.pixelSize: Theme.font.bodySmall
    }
}
