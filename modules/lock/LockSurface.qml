pragma ComponentBehavior: Bound

// NoSignal lock screen surface (interface redesign 2026-06-14).
// Secure ext-session-lock content: blurred wallpaper + scrim, top status row,
// centred clock/date/avatar/username/password, bottom now-playing strip.
// Reuses caelestia's Pam (buffer + handleKey + state) for PAM auth and the
// WlSessionLock unlock signal — input is fed to pam.handleKey, never compared
// in QML. JetBrains Mono / Nerd Font / NoSignal Theme tokens.

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import Caelestia.Config
import qs.components
import qs.services
import qs.utils

WlSessionLockSurface {
    id: root

    required property WlSessionLock lock
    required property Pam pam

    readonly property bool errored: root.pam.state === "error" || root.pam.state === "fail"

    contentItem.Config.screen: screen?.name ?? ""
    contentItem.Tokens.screen: screen?.name ?? ""

    color: "transparent"

    Connections {
        function onUnlock(): void {
            root.lock.locked = false;
        }
        target: root.lock
    }

    // ── Blurred wallpaper + scrim ──────────────────────────────────────────
    ScreencopyView {
        id: background

        anchors.fill: parent
        captureSource: root.screen

        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: false
            blurEnabled: true
            blur: 1
            blurMax: 64
            blurMultiplier: 1
            brightness: -0.38
            saturation: 0.1
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(8 / 255, 10 / 255, 14 / 255, 0.5)
    }

    // ── Keyboard capture (feed PAM; Escape does nothing) ───────────────────
    Item {
        anchors.fill: parent
        focus: true
        Component.onCompleted: forceActiveFocus()
        Keys.onPressed: event => root.pam.handleKey(event)
    }

    // ── Top status row ─────────────────────────────────────────────────────
    RowLayout {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 22
        anchors.leftMargin: 28
        anchors.rightMargin: 28

        RowLayout {
            spacing: 7
            NsIcon {
                icon: "lock"
                color: Theme.textMuted
                size: 15
            }
            StyledText {
                text: "Locked"
                color: Theme.textMuted
                font.family: Theme.font.family
                font.pixelSize: Theme.font.bar
            }
        }

        Item {
            Layout.fillWidth: true
        }

        RowLayout {
            spacing: 14

            NsIcon {
                icon: Nmcli.active ? Icons.getNetworkIcon(Nmcli.active.strength ?? 0) : "wifi_off"
                color: Theme.textMuted
                size: 15
            }
            NsIcon {
                icon: Bluetooth.defaultAdapter?.enabled ? "bluetooth_connected" : "bluetooth_disabled"
                color: Theme.textMuted
                size: 15
            }
            RowLayout {
                spacing: 6
                visible: UPower.displayDevice.isLaptopBattery
                NsIcon {
                    icon: Icons.getBatteryIcon(UPower.displayDevice.percentage, [UPowerDeviceState.Charging, UPowerDeviceState.FullyCharged].includes(UPower.displayDevice.state))
                    color: Theme.textMuted
                    size: 15
                }
                StyledText {
                    text: Math.round(UPower.displayDevice.percentage * 100) + "%"
                    color: Theme.textMuted
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.bar
                }
            }
        }
    }

    // ── Centre block ───────────────────────────────────────────────────────
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 0

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: Time.format("hh:mm")
            color: Theme.text
            font.family: Theme.font.family
            font.pixelSize: 108
            font.weight: Font.ExtraLight
            font.letterSpacing: 3
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: Time.format("ddd, d MMMM yyyy")
            color: Theme.textMuted
            font.family: Theme.font.family
            font.pixelSize: 15
        }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 64
            implicitWidth: 74
            implicitHeight: 74
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
            NsIcon {
                anchors.centerIn: parent
                icon: "person"
                color: Theme.onAccent
                size: 34
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 14
            text: SysInfo.user || "user"
            color: Theme.text
            font.family: Theme.font.family
            font.pixelSize: 14
        }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 16
            implicitWidth: 312
            implicitHeight: 44
            radius: Theme.radius.panel
            color: Qt.rgba(17 / 255, 20 / 255, 26 / 255, 0.55)
            border.width: 1
            border.color: root.errored ? Qt.rgba(224 / 255, 116 / 255, 106 / 255, 0.6) : Qt.rgba(1, 1, 1, 0.1)

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 12
                spacing: 10

                NsIcon {
                    icon: "key"
                    color: Theme.textMuted
                    size: 15
                }

                StyledText {
                    Layout.fillWidth: true
                    text: root.pam.buffer.length > 0 ? "•".repeat(root.pam.buffer.length) : "Enter password"
                    color: root.pam.buffer.length > 0 ? Theme.text : Theme.textFaint
                    elide: Text.ElideRight
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.body
                    font.letterSpacing: root.pam.buffer.length > 0 ? 2 : 0
                }

                NsIcon {
                    icon: "login"
                    color: root.pam.buffer.length > 0 ? Theme.accent : Theme.textFaint
                    size: 16

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -6
                        cursorShape: Qt.PointingHandCursor
                        onClicked: if (root.pam.buffer.length > 0)
                            root.pam.passwd.start()
                    }
                }
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 8
            Layout.preferredHeight: 14
            text: root.errored ? "Incorrect — try again" : (root.pam.lockMessage || "")
            color: Theme.danger
            font.family: Theme.font.family
            font.pixelSize: 12
        }
    }

    // ── Bottom strip ───────────────────────────────────────────────────────
    RowLayout {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: 26
        anchors.leftMargin: 28
        anchors.rightMargin: 28

        RowLayout {
            spacing: 10
            visible: Players.active !== null

            Rectangle {
                implicitWidth: 42
                implicitHeight: 42
                radius: Theme.radius.panel
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
                NsIcon {
                    anchors.centerIn: parent
                    icon: "music_note"
                    color: Theme.onAccent
                    size: 18
                }
            }

            ColumnLayout {
                spacing: 0
                StyledText {
                    text: Players.active?.trackTitle || ""
                    color: Theme.text
                    elide: Text.ElideRight
                    Layout.maximumWidth: 280
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.bodySmall
                }
                StyledText {
                    text: Players.active?.trackArtist || ""
                    color: Theme.textMuted
                    elide: Text.ElideRight
                    Layout.maximumWidth: 280
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.meta
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        StyledText {
            text: "Press Enter to unlock"
            color: Theme.textFaint
            font.family: Theme.font.family
            font.pixelSize: 11
        }
    }
}
