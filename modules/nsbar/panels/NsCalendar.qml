pragma ComponentBehavior: Bound

// NoSignal Calendar popout (off the center clock). Month grid (Mon-first),
// today = filled accent circle. Below a divider, a TODAY events section
// (empty-state for now; real events can be wired from ICS/khal later).

import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

NsPanel {
    id: root

    implicitWidth: 304
    anchorMode: "center"

    property int monthOffset: 0
    readonly property date base: new Date(Time.date.getFullYear(), Time.date.getMonth() + monthOffset, 1)
    readonly property int year: base.getFullYear()
    readonly property int month: base.getMonth()
    readonly property bool isCurrentMonth: monthOffset === 0
    readonly property int todayDate: Time.date.getDate()

    readonly property var cells: {
        const first = new Date(year, month, 1);
        const lead = (first.getDay() + 6) % 7; // Monday-first
        const dim = new Date(year, month + 1, 0).getDate();
        const arr = [];
        for (let i = 0; i < lead; i++)
            arr.push(0);
        for (let d = 1; d <= dim; d++)
            arr.push(d);
        return arr;
    }

    // ── Header: month + year, prev/next ──────────────────────────────────
    RowLayout {
        Layout.fillWidth: true

        ColumnLayout {
            spacing: 0

            StyledText {
                text: root.base.toLocaleString(Qt.locale(), "MMMM")
                color: Theme.text
                font.family: Theme.font.family
                font.pixelSize: Theme.font.panelTitle
                font.weight: Font.DemiBold
            }

            StyledText {
                text: root.year
                color: Theme.textMuted
                font.family: Theme.font.family
                font.pixelSize: Theme.font.bodySmall
            }
        }

        Item {
            Layout.fillWidth: true
        }

        NavBtn {
            icon: "chevron_left"
            onActivated: root.monthOffset--
        }

        NavBtn {
            icon: "chevron_right"
            onActivated: root.monthOffset++
        }
    }

    // ── Grid: weekday header + days ──────────────────────────────────────
    GridLayout {
        Layout.fillWidth: true
        columns: 7
        rowSpacing: 2
        columnSpacing: 0

        Repeater {
            model: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

            StyledText {
                required property string modelData

                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                text: modelData
                color: Theme.textFaint
                font.family: Theme.font.family
                font.pixelSize: Theme.font.label
            }
        }

        Repeater {
            model: root.cells

            Item {
                required property int modelData
                readonly property bool today: root.isCurrentMonth && modelData === root.todayDate

                Layout.fillWidth: true
                implicitHeight: 30

                Rectangle {
                    anchors.centerIn: parent
                    visible: parent.modelData > 0
                    implicitWidth: 26
                    implicitHeight: 26
                    radius: 0
                    color: parent.today ? Theme.accent : "transparent"

                    StyledText {
                        anchors.centerIn: parent
                        text: parent.parent.modelData > 0 ? parent.parent.modelData : ""
                        color: parent.parent.today ? Theme.onAccent : Theme.text
                        font.family: Theme.font.family
                        font.pixelSize: Theme.font.bodySmall
                    }
                }
            }
        }
    }

    // ── Divider ──────────────────────────────────────────────────────────
    Rectangle {
        Layout.fillWidth: true
        Layout.topMargin: 4
        implicitHeight: 1
        color: Theme.barBorder
    }

    // ── TODAY events ─────────────────────────────────────────────────────
    StyledText {
        text: "TODAY"
        color: Theme.textFaint
        font.family: Theme.font.family
        font.pixelSize: Theme.font.label
        font.letterSpacing: Theme.font.trackingLabel
    }

    StyledText {
        text: "No events"
        color: Theme.textMuted
        font.family: Theme.font.family
        font.pixelSize: Theme.font.bodySmall
    }

    component NavBtn: Rectangle {
        property string icon
        signal activated

        implicitWidth: 24
        implicitHeight: 24
        radius: Theme.radius.button
        color: ma.containsMouse ? Theme.hover : "transparent"

        NsIcon {
            anchors.centerIn: parent
            icon: parent.icon
            color: Theme.textMuted
        }

        MouseArea {
            id: ma

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: parent.activated()
        }
    }
}
