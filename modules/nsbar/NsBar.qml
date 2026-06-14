pragma ComponentBehavior: Bound

// NoSignal slim top bar (interface redesign 2026-06-14).
// Flat 38px translucent-glass PanelWindow at the top edge. Three zones:
//   left  : logo · | · workspaces · | · window-title
//   center: clock
//   right : media · bell · wifi · bt · volume · battery · | · power
// Each interactive module is a BarPill (hover bg; active = accent.soft + accent
// fg). `openPanel` is the single shell-level "one panel open at a time" string;
// clicking a pill toggles it. The popup panels themselves are built next — for
// now a click just highlights the pill. Reuses the existing service singletons.

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import qs.services
import qs.utils
import qs.components
import qs.modules.bar.components as BC
import qs.modules.bar.components.workspaces as WS

Variants {
    model: Screens.screens

    PanelWindow {
        id: win

        required property ShellScreen modelData

        screen: modelData
        color: "transparent"
        WlrLayershell.namespace: "nsbar" // for Hyprland blur layerrule
        WlrLayershell.layer: WlrLayer.Top

        anchors.top: true
        anchors.left: true
        anchors.right: true

        implicitHeight: Theme.size.barHeight
        exclusiveZone: Theme.size.barHeight

        readonly property int hPad: 12
        readonly property int gap: 6

        // ── Glass surface + 1px bottom border ──────────────────────────────
        Rectangle {
            anchors.fill: parent
            color: Theme.barBg

            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 1
                color: Theme.barBorder
            }
        }

        // ── Left zone ──────────────────────────────────────────────────────
        RowLayout {
            anchors.left: parent.left
            anchors.leftMargin: win.hPad
            anchors.verticalCenter: parent.verticalCenter
            spacing: win.gap

            BC.OsIcon {}

            Divider {}

            NsWorkspaces {}

            Divider {}

            BarPill {
                id: titlePill

                active: NsShell.open === "overview"
                onTriggered: NsShell.toggle("overview", mapToItem(null, width / 2, 0).x)

                NsIcon {
                    icon: "desktop_windows"
                    color: titlePill.active ? Theme.accent : Theme.textMuted
                }

                StyledText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Hypr.activeToplevel?.title ?? "Desktop"
                    elide: Text.ElideRight
                    width: Math.min(implicitWidth, 220)
                    color: titlePill.active ? Theme.accent : Theme.text
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.bar
                }
            }
        }

        // ── Center zone: clock ─────────────────────────────────────────────
        BarPill {
            id: clockPill

            anchors.centerIn: parent
            active: NsShell.open === "calendar"
            onTriggered: NsShell.toggle("calendar", mapToItem(null, width / 2, 0).x)

            BC.Clock {}
        }

        // ── Right zone ─────────────────────────────────────────────────────
        RowLayout {
            anchors.right: parent.right
            anchors.rightMargin: win.hPad
            anchors.verticalCenter: parent.verticalCenter
            spacing: win.gap

            // Media / now-playing
            BarPill {
                id: mediaPill

                visible: Players.active !== null
                active: NsShell.open === "quicksettings"
                onTriggered: NsShell.toggle("quicksettings", mapToItem(null, width / 2, 0).x)

                NsIcon {
                    icon: Players.active?.isPlaying ? "pause" : "music_note"
                    color: mediaPill.active ? Theme.accent : Theme.green
                }

                StyledText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Players.active?.trackTitle || "Awake"
                    elide: Text.ElideRight
                    width: Math.min(implicitWidth, 90)
                    color: mediaPill.active ? Theme.accent : Theme.text
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.bar
                }
            }

            // System tray
            IconPill {
                icon: "widgets"
                panel: "tray"
            }

            // Notifications bell (with unread dot overlaid on the icon)
            BarPill {
                id: bellPill

                active: NsShell.open === "notifications"
                onTriggered: NsShell.toggle("notifications", mapToItem(null, width / 2, 0).x)

                NsIcon {
                    icon: Notifs.notClosed.length > 0 ? "notifications" : "notifications_none"
                    color: bellPill.active ? Theme.accent : Theme.text

                    Rectangle {
                        visible: Notifs.notClosed.length > 0
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.rightMargin: -1
                        anchors.topMargin: 1
                        implicitWidth: 6
                        implicitHeight: 6
                        radius: 0
                        color: Theme.accent
                    }
                }
            }

            // Wi-Fi
            IconPill {
                icon: Nmcli.active ? Icons.getNetworkIcon(Nmcli.active.strength ?? 0) : "wifi_off"
                panel: "network"
            }

            // Bluetooth
            IconPill {
                icon: {
                    if (!Bluetooth.defaultAdapter?.enabled)
                        return "bluetooth_disabled";
                    if (Bluetooth.devices.values.some(d => d.connected))
                        return "bluetooth_connected";
                    return "bluetooth";
                }
                panel: "bluetooth"
            }

            // Volume
            IconPill {
                icon: Icons.getVolumeIcon(Audio.volume, Audio.muted)
                panel: "audio"
            }

            // Battery / Quick Settings — always present (control-centre trigger):
            // battery + % on laptops, a "tune" icon on desktops.
            BarPill {
                id: batteryPill

                readonly property bool laptop: UPower.displayDevice.isLaptopBattery
                active: NsShell.open === "quicksettings"
                onTriggered: NsShell.toggle("quicksettings", mapToItem(null, width / 2, 0).x)

                NsIcon {
                    icon: batteryPill.laptop ? Icons.getBatteryIcon(UPower.displayDevice.percentage, [UPowerDeviceState.Charging, UPowerDeviceState.FullyCharged, UPowerDeviceState.PendingCharge].includes(UPower.displayDevice.state)) : "tune"
                    color: batteryPill.active ? Theme.accent : !batteryPill.laptop || !UPower.onBattery || UPower.displayDevice.percentage > 0.2 ? Theme.text : Theme.danger
                    fill: 1
                }

                StyledText {
                    visible: batteryPill.laptop
                    anchors.verticalCenter: parent.verticalCenter
                    text: Math.round(UPower.displayDevice.percentage * 100) + "%"
                    color: batteryPill.active ? Theme.accent : Theme.text
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.bar
                }
            }

            Divider {}

            // Power
            IconPill {
                icon: "power_settings_new"
                panel: "power"
                iconColour: Theme.danger
            }
        }

        // ── Reusable bits ──────────────────────────────────────────────────
        component Divider: Rectangle {
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: 1
            implicitHeight: 16
            color: Theme.barBorder
        }

        // Icon-only pill bound to the shell openPanel state
        component IconPill: BarPill {
            id: p

            property string icon
            property string panel
            property color iconColour: Theme.text

            active: NsShell.open === panel
            onTriggered: NsShell.toggle(panel, mapToItem(null, width / 2, 0).x)

            NsIcon {
                icon: p.icon
                color: p.active ? Theme.accent : p.iconColour
            }
        }
    }
}
