pragma ComponentBehavior: Bound

// NoSignal redesign: center clock module — date (muted) + time (DemiBold),
// JetBrains Mono. The hover/active pill is applied by the bar module wrapper;
// this is just the content. Opens the Calendar popout.

import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services

RowLayout {
    id: root

    spacing: 8

    StyledText {
        Layout.alignment: Qt.AlignVCenter
        text: Time.format("ddd d MMM")
        color: Theme.textMuted
        font.family: Theme.font.family
        font.pixelSize: Theme.font.bar
        font.weight: Font.Normal
    }

    StyledText {
        Layout.alignment: Qt.AlignVCenter
        text: Time.format("hh:mm")
        color: Theme.text
        font.family: Theme.font.family
        font.pixelSize: Theme.font.bar
        font.weight: Font.DemiBold
    }
}
