pragma ComponentBehavior: Bound

// NoSignal popup overlay: one full-screen layer per screen that hosts the active
// floating panel (driven by NsShell.open). A transparent click-catcher behind the
// panel closes on outside-click; Escape also closes. Panels are positioned below
// the bar, anchored center / right / under-trigger per their `anchorMode`.

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.services
import "panels" as Panels

Variants {
    model: Screens.screens

    PanelWindow {
        id: ov

        required property ShellScreen modelData

        // This overlay owns the panel only when NsShell.screen names this output
        // (or is "" = unscoped, e.g. the global power modal → show on all screens).
        // Without this, every screen's overlay rendered the panel → mirrored popups.
        readonly property bool onThisScreen: NsShell.screen === "" || NsShell.screen === modelData.name

        screen: modelData
        visible: NsShell.open !== "" && ov.onThisScreen
        color: "transparent"
        WlrLayershell.namespace: "nspanels"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

        anchors.top: true
        anchors.bottom: true
        anchors.left: true
        anchors.right: true
        exclusiveZone: 0

        // outside-click closes
        MouseArea {
            anchors.fill: parent
            onClicked: NsShell.close()
        }

        // Escape closes
        Item {
            anchors.fill: parent
            focus: ov.visible
            Keys.onEscapePressed: NsShell.close()
        }

        // full-screen modal: Power Menu
        Loader {
            anchors.fill: parent
            active: NsShell.open === "power" && ov.onThisScreen
            sourceComponent: powerC

            Component {
                id: powerC

                Panels.NsPowerMenu {}
            }
        }

        Loader {
            id: loader

            active: NsShell.open !== "" && NsShell.open !== "power" && ov.onThisScreen
            y: Theme.size.barHeight + 6
            x: {
                if (!item)
                    return 0;
                const w = item.implicitWidth;
                const mode = item.anchorMode ?? "right";
                if (mode === "center")
                    return Math.round((ov.width - w) / 2);
                if (mode === "trigger")
                    return Math.max(8, Math.min(ov.width - w - 8, NsShell.anchorX - w / 2));
                return ov.width - w - 12; // right
            }

            // small enter slide
            opacity: active ? 1 : 0
            transform: Translate {
                y: loader.active ? 0 : -5
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 120
                }
            }

            sourceComponent: {
                switch (NsShell.open) {
                case "calendar":
                    return calendarC;
                case "quicksettings":
                    return quickSettingsC;
                case "network":
                    return networkC;
                case "bluetooth":
                    return bluetoothC;
                case "notifications":
                    return notificationsC;
                case "audio":
                    return audioC;
                case "tray":
                    return trayC;
                case "overview":
                    return overviewC;
                default:
                    return null;
                }
            }

            Component {
                id: calendarC

                Panels.NsCalendar {}
            }

            Component {
                id: quickSettingsC

                Panels.NsQuickSettings {}
            }

            Component {
                id: networkC

                Panels.NsNetwork {}
            }

            Component {
                id: bluetoothC

                Panels.NsBluetooth {}
            }

            Component {
                id: notificationsC

                Panels.NsNotifications {}
            }

            Component {
                id: audioC

                Panels.NsAudio {}
            }

            Component {
                id: trayC

                Panels.NsSystemTray {}
            }

            Component {
                id: overviewC

                Panels.NsOverview {}
            }
        }
    }
}
