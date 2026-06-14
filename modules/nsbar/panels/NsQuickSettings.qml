pragma ComponentBehavior: Bound

// NoSignal Quick Settings popout (off the media / battery pill). Avatar + user +
// uptime + power button; 2-col toggle grid; brightness + volume sliders; media
// card. Wired to the real services (Network, Bluetooth, Notifs, Audio,
// Brightness, Players); Night Light / Airplane / VPN are stateful toggles for now.

import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import qs.services
import qs.utils
import qs.components

NsPanel {
    id: root

    implicitWidth: 380
    anchorMode: "right"

    readonly property var brightMon: Brightness.monitors[0] ?? null

    // ── Header ───────────────────────────────────────────────────────────
    RowLayout {
        Layout.fillWidth: true
        spacing: 12

        Rectangle {
            implicitWidth: 40
            implicitHeight: 40
            radius: 20
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop {
                    position: 0
                    color: Theme.accent
                }
                GradientStop {
                    position: 1
                    color: Theme.blue
                }
            }

            StyledText {
                anchors.centerIn: parent
                text: (SysInfo.user || "?").charAt(0).toUpperCase()
                color: Theme.onAccent
                font.family: Theme.font.family
                font.pixelSize: Theme.font.body
                font.weight: Font.Bold
            }
        }

        ColumnLayout {
            spacing: 0
            StyledText {
                text: SysInfo.user || "user"
                color: Theme.text
                font.family: Theme.font.family
                font.pixelSize: Theme.font.panelTitle
                font.weight: Font.DemiBold
            }
            StyledText {
                text: "uptime " + SysInfo.uptime
                color: Theme.textMuted
                font.family: Theme.font.family
                font.pixelSize: Theme.font.bodySmall
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Rectangle {
            implicitWidth: 34
            implicitHeight: 34
            radius: 17
            color: pwrMa.containsMouse ? Theme.accentSoft : Theme.fillSubtle

            MaterialIcon {
                anchors.centerIn: parent
                text: "power_settings_new"
                color: Theme.danger
            }

            MouseArea {
                id: pwrMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: NsShell.show("power", 0)
            }
        }
    }

    // ── Toggle grid ──────────────────────────────────────────────────────
    GridLayout {
        Layout.fillWidth: true
        columns: 2
        rowSpacing: 8
        columnSpacing: 8

        QSToggle {
            icon: "wifi"
            label: "Wi-Fi"
            sub: Network.wifiEnabled ? Network.active?.ssid ?? "On" : "Off"
            on: Network.wifiEnabled
            onToggled: Network.toggleWifi()
        }
        QSToggle {
            icon: "bluetooth"
            label: "Bluetooth"
            sub: Bluetooth.defaultAdapter?.enabled ? "On" : "Off"
            on: Bluetooth.defaultAdapter?.enabled ?? false
            onToggled: if (Bluetooth.defaultAdapter)
                Bluetooth.defaultAdapter.enabled = !Bluetooth.defaultAdapter.enabled
        }
        QSToggle {
            icon: "do_not_disturb_on"
            label: "Do Not Disturb"
            sub: Notifs.dnd ? "On" : "Off"
            on: Notifs.dnd
            onToggled: Notifs.dnd = !Notifs.dnd
        }
        QSToggle {
            id: nightTog
            icon: "nightlight"
            label: "Night Light"
            sub: on ? "Warm 3500K" : "Off"
            onToggled: on = !on
        }
        QSToggle {
            id: airTog
            icon: "airplanemode_active"
            label: "Airplane"
            sub: on ? "On" : "Off"
            onToggled: on = !on
        }
        QSToggle {
            id: vpnTog
            icon: "vpn_key"
            label: "VPN"
            sub: on ? "On" : "Off"
            onToggled: on = !on
        }
    }

    // ── Sliders ──────────────────────────────────────────────────────────
    QSSlider {
        icon: "brightness_6"
        value: root.brightMon?.brightness ?? 0
        visible: root.brightMon !== null
        onMoved: v => root.brightMon?.setBrightness(v)
    }

    QSSlider {
        icon: Audio.muted ? "volume_off" : "volume_up"
        value: Audio.volume
        onMoved: v => Audio.setVolume(v)
    }

    // ── Media card ───────────────────────────────────────────────────────
    Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 4
        implicitHeight: 80
        radius: Theme.radius.tile
        color: Theme.fillSubtle
        visible: Players.active !== null

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            Rectangle {
                implicitWidth: 56
                implicitHeight: 56
                radius: 0
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop {
                        position: 0
                        color: Theme.accent
                    }
                    GradientStop {
                        position: 1
                        color: Theme.blue
                    }
                }
                MaterialIcon {
                    anchors.centerIn: parent
                    text: "music_note"
                    color: Theme.onAccent
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                StyledText {
                    Layout.fillWidth: true
                    text: Players.active?.trackTitle || "Awake"
                    color: Theme.text
                    elide: Text.ElideRight
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.body
                    font.weight: Font.DemiBold
                }
                StyledText {
                    Layout.fillWidth: true
                    text: Players.active?.trackArtist || ""
                    color: Theme.textMuted
                    elide: Text.ElideRight
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.bodySmall
                }

                RowLayout {
                    spacing: 16
                    Layout.topMargin: 2

                    MediaBtn {
                        icon: "skip_previous"
                        onActivated: Players.previous()
                    }
                    MediaBtn {
                        icon: Players.active?.isPlaying ? "pause" : "play_arrow"
                        onActivated: Players.togglePlaying()
                    }
                    MediaBtn {
                        icon: "skip_next"
                        onActivated: Players.next()
                    }
                }
            }
        }
    }

    // ── Reusable bits ────────────────────────────────────────────────────
    component QSToggle: Rectangle {
        id: tile

        property string icon
        property string label
        property string sub
        property bool on: false
        signal toggled

        Layout.fillWidth: true
        implicitHeight: 56
        radius: Theme.radius.button
        color: tile.on ? Theme.accentSoft : Theme.fillSubtle
        border.width: tile.on ? 1 : 0
        border.color: Theme.accent

        RowLayout {
            anchors.fill: parent
            anchors.margins: 11
            spacing: 10

            Rectangle {
                implicitWidth: 30
                implicitHeight: 30
                radius: 15
                color: tile.on ? Theme.accent : Qt.rgba(1, 1, 1, 0.06)

                MaterialIcon {
                    anchors.centerIn: parent
                    text: tile.icon
                    color: tile.on ? Theme.onAccent : Theme.text
                }
            }

            ColumnLayout {
                spacing: 0
                StyledText {
                    text: tile.label
                    color: Theme.text
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.bodySmall
                    font.weight: Font.Medium
                }
                StyledText {
                    text: tile.sub
                    color: Theme.textMuted
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.meta
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: tile.toggled()
        }
    }

    component QSSlider: RowLayout {
        id: s

        property string icon
        property real value: 0
        signal moved(real v)

        Layout.fillWidth: true
        spacing: 10

        MaterialIcon {
            text: s.icon
            color: Theme.textMuted
        }

        Rectangle {
            id: track

            Layout.fillWidth: true
            implicitHeight: 6
            radius: 3
            color: Theme.fillSubtle

            Rectangle {
                width: parent.width * Math.max(0, Math.min(1, s.value))
                height: parent.height
                radius: 3
                color: Theme.accent
            }

            Rectangle {
                x: parent.width * Math.max(0, Math.min(1, s.value)) - width / 2
                anchors.verticalCenter: parent.verticalCenter
                implicitWidth: 14
                implicitHeight: 14
                radius: 7
                color: Theme.accent
            }

            MouseArea {
                anchors.fill: parent
                onPressed: e => s.moved(Math.max(0, Math.min(1, e.x / width)))
                onPositionChanged: e => {
                    if (pressed)
                        s.moved(Math.max(0, Math.min(1, e.x / width)));
                }
            }
        }

        StyledText {
            text: Math.round(s.value * 100) + "%"
            color: Theme.textMuted
            font.family: Theme.font.family
            font.pixelSize: Theme.font.meta
        }
    }

    component MediaBtn: Rectangle {
        property string icon
        signal activated

        implicitWidth: 28
        implicitHeight: 28
        radius: 14
        color: mbm.containsMouse ? Theme.hover : "transparent"

        MaterialIcon {
            anchors.centerIn: parent
            text: parent.icon
            color: Theme.text
        }

        MouseArea {
            id: mbm
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.activated()
        }
    }
}
