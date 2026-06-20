pragma ComponentBehavior: Bound

// NoSignal Network popout (off the Wi-Fi pill). Title + switch; list of networks
// (signal glyph accent if connected, SSID, Connected label, lock if secured);
// connected row = accent.soft. Footer "Network settings". Wired to Network/Nmcli.
//
// FIX 2026-06-20 (hardware test): the shipped panel was display-only — the row
// MouseArea had no onClicked and there was no password field, so a secured Wi-Fi
// network could not be joined from the GUI (user had to drop to nmcli/nmtui).
// This wires the existing Network service: click a row to connect; open or
// already-saved networks connect directly; a secured network with no saved
// profile expands an inline password field (StyledTextField, echoMode Password).
// NsOverlay grants OnDemand keyboard focus while visible, so the field is typable.
// NOTE: authored on the test machine but NOT yet built/cert'd — review in builder.

import QtQuick
import QtQuick.Layouts
import qs.services
import qs.utils
import qs.components
import qs.components.controls

NsPanel {
    id: root

    implicitWidth: 340
    anchorMode: "right"

    // ssid of the secured row currently showing its inline password field ("" = none)
    property string expandedSsid: ""

    // Decide what a click on a network row does.
    function activate(m): void {
        if (!m)
            return;
        if (m.active) {
            // Already connected -> tapping disconnects.
            Network.disconnectFromNetwork();
            root.expandedSsid = "";
            return;
        }
        if (!m.isSecure || Network.hasSavedProfile(m.ssid)) {
            // Open network, or we already hold the PSK -> connect straight away.
            Network.connectToNetworkWithPasswordCheck(m.ssid, m.isSecure, () => {}, m.bssid);
            root.expandedSsid = "";
        } else {
            // Secured + no saved profile -> reveal the inline password field.
            root.expandedSsid = (root.expandedSsid === m.ssid) ? "" : m.ssid;
        }
    }

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

            delegate: ColumnLayout {
                id: rowWrap

                required property var modelData
                readonly property bool connected: modelData?.active ?? false
                readonly property bool expanded: root.expandedSsid === (modelData?.ssid ?? " ")

                Layout.fillWidth: true
                spacing: 2

                function doConnect(): void {
                    const m = rowWrap.modelData;
                    if (!m || pwField.text.length === 0)
                        return;
                    Network.connectToNetwork(m.ssid, pwField.text, m.bssid, () => {});
                    pwField.text = "";
                    root.expandedSsid = "";
                }

                Rectangle {
                    id: row

                    Layout.fillWidth: true
                    implicitHeight: 40
                    radius: Theme.radius.button
                    color: rowWrap.connected ? Theme.accentSoft : ma.containsMouse ? Theme.hover : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 10

                        NsIcon {
                            icon: Icons.getNetworkIcon(rowWrap.modelData?.strength ?? 0)
                            color: rowWrap.connected ? Theme.accent : Theme.text
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            StyledText {
                                text: rowWrap.modelData?.ssid ?? "?"
                                color: Theme.text
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                                font.family: Theme.font.family
                                font.pixelSize: Theme.font.bodySmall
                            }
                            StyledText {
                                visible: rowWrap.connected
                                text: "Connected"
                                color: Theme.accent
                                font.family: Theme.font.family
                                font.pixelSize: Theme.font.meta
                            }
                        }

                        NsIcon {
                            visible: rowWrap.modelData?.isSecure ?? false
                            icon: "lock"
                            color: Theme.textFaint
                        }
                    }

                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.activate(rowWrap.modelData)
                    }
                }

                // inline password entry — only for a secured network with no saved profile
                RowLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: 10
                    Layout.rightMargin: 10
                    Layout.bottomMargin: 4
                    spacing: 8
                    visible: rowWrap.expanded

                    onVisibleChanged: {
                        if (visible)
                            pwField.forceActiveFocus();
                    }

                    StyledTextField {
                        id: pwField

                        Layout.fillWidth: true
                        echoMode: TextField.Password
                        placeholderText: "Password"
                        onAccepted: rowWrap.doConnect()
                    }

                    Rectangle {
                        implicitWidth: 72
                        implicitHeight: 28
                        radius: Theme.radius.button
                        color: cma.containsMouse ? Theme.accent : Theme.accentSoft

                        StyledText {
                            anchors.centerIn: parent
                            text: "Connect"
                            color: Theme.text
                            font.family: Theme.font.family
                            font.pixelSize: Theme.font.meta
                        }

                        MouseArea {
                            id: cma
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: rowWrap.doConnect()
                        }
                    }
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
