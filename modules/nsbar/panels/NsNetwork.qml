pragma ComponentBehavior: Bound

// NoSignal Network popout (off the Wi-Fi pill). Title + switch; list of networks
// (signal glyph accent if connected, SSID, Connected label, lock if secured);
// connected row = accent.soft. Footer "Network settings". Wired to Network/Nmcli.

import QtQuick
import QtQuick.Layouts
import qs.services
import qs.utils
import qs.components

NsPanel {
    id: root

    implicitWidth: 340
    anchorMode: "right"

    RowLayout {
        Layout.fillWidth: true

        StyledText {
            text: "Wi-Fi"
            color: Theme.text
            font.family: Theme.font.family
            font.pixelSize: Theme.font.panelTitle
            font.weight: Font.DemiBold
        }

        Item {
            Layout.fillWidth: true
        }

        NsSwitch {
            on: Network.wifiEnabled
            onToggled: Network.toggleWifi()
        }
    }

    // network list
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        visible: Network.wifiEnabled

        Repeater {
            model: Network.networks

            delegate: Rectangle {
                id: row

                required property var modelData
                readonly property bool connected: modelData?.active ?? false

                Layout.fillWidth: true
                implicitHeight: 40
                radius: Theme.radius.button
                color: connected ? Theme.accentSoft : ma.containsMouse ? Theme.hover : "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    spacing: 10

                    MaterialIcon {
                        text: Icons.getNetworkIcon(row.modelData?.strength ?? 0)
                        color: row.connected ? Theme.accent : Theme.text
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        StyledText {
                            text: row.modelData?.ssid ?? "?"
                            color: Theme.text
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                            font.family: Theme.font.family
                            font.pixelSize: Theme.font.bodySmall
                        }
                        StyledText {
                            visible: row.connected
                            text: "Connected"
                            color: Theme.accent
                            font.family: Theme.font.family
                            font.pixelSize: Theme.font.meta
                        }
                    }

                    MaterialIcon {
                        visible: row.modelData?.isSecure ?? false
                        text: "lock"
                        color: Theme.textFaint
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
            visible: Network.networks.length === 0
            text: "No networks found"
            color: Theme.textMuted
            font.family: Theme.font.family
            font.pixelSize: Theme.font.bodySmall
        }
    }

    StyledText {
        visible: !Network.wifiEnabled
        text: "Wi-Fi is off"
        color: Theme.textMuted
        font.family: Theme.font.family
        font.pixelSize: Theme.font.bodySmall
    }

    // footer
    Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 4
        implicitHeight: 1
        color: Theme.barBorder
    }

    StyledText {
        text: "Network settings"
        color: Theme.textMuted
        font.family: Theme.font.family
        font.pixelSize: Theme.font.bodySmall
    }
}
