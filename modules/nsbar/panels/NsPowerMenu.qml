pragma ComponentBehavior: Bound

// NoSignal Power Menu — full-screen modal overlay. Big clock + date, then 5
// action tiles (Lock, Suspend, Log Out, Reboot, Shut Down=danger). Esc / click
// scrim cancels. Rendered full-screen by NsOverlay (open === "power").

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.components

Item {
    id: root

    function run(cmd: string): void {
        Quickshell.execDetached(["sh", "-c", cmd]);
        NsShell.close();
    }

    // scrim
    Rectangle {
        anchors.fill: parent
        color: Theme.overlayBg

        MouseArea {
            anchors.fill: parent
            onClicked: NsShell.close()
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 28

        // big clock + date
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 2

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: Time.format("hh:mm")
                color: Theme.text
                font.family: Theme.font.family
                font.pixelSize: Theme.font.clockBig
                font.weight: Font.Light
                font.letterSpacing: Theme.font.trackingClockBig
            }
            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: Time.format("dddd, d MMMM")
                color: Theme.textMuted
                font.family: Theme.font.family
                font.pixelSize: Theme.font.body
            }
        }

        // action tiles
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 14

            Tile {
                icon: "lock"
                label: "Lock"
                onActivated: root.run("loginctl lock-session")
            }
            Tile {
                icon: "bedtime"
                label: "Suspend"
                onActivated: root.run("systemctl suspend")
            }
            Tile {
                icon: "logout"
                label: "Log Out"
                onActivated: root.run("hyprctl dispatch exit")
            }
            Tile {
                icon: "restart_alt"
                label: "Reboot"
                onActivated: root.run("systemctl reboot")
            }
            Tile {
                icon: "power_settings_new"
                label: "Shut Down"
                danger: true
                onActivated: root.run("systemctl poweroff")
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: "Press Esc to cancel"
            color: Theme.textFaint
            font.family: Theme.font.family
            font.pixelSize: Theme.font.bodySmall
        }
    }

    component Tile: Rectangle {
        id: tile

        property string icon
        property string label
        property bool danger: false
        signal activated

        implicitWidth: 96
        implicitHeight: 96
        radius: Theme.radius.panel
        color: ma.containsMouse ? Theme.accentSoft : Theme.panelBg
        border.width: 1
        border.color: ma.containsMouse ? (tile.danger ? Theme.danger : Theme.accent) : Theme.panelBorder

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10

            MaterialIcon {
                Layout.alignment: Qt.AlignHCenter
                text: tile.icon
                color: tile.danger ? Theme.danger : Theme.text
            }

            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: tile.label
                color: tile.danger ? Theme.danger : Theme.text
                font.family: Theme.font.family
                font.pixelSize: Theme.font.bodySmall
            }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: tile.activated()
        }
    }
}
