pragma ComponentBehavior: Bound

// NoSignal floating popout container: dark-glass card, 1px border, 4px radius.
// Content goes in a ColumnLayout (default children). Sizes to its content height;
// set `width` on the instance. A background MouseArea swallows clicks so clicking
// inside the panel doesn't fall through to the overlay's close-catcher.

import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
    id: root

    property int pad: Theme.size.panelPad
    property alias spacing: holder.spacing
    default property alias content: holder.data

    // anchoring hint read by NsOverlay: "center" | "right" | "trigger"
    property string anchorMode: "right"

    implicitHeight: holder.implicitHeight + root.pad * 2
    color: Theme.panelBg
    radius: Theme.radius.panel
    border.width: 1
    border.color: Theme.panelBorder

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        // swallow clicks/hover so they don't reach the overlay close-catcher
    }

    ColumnLayout {
        id: holder

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: root.pad
        spacing: Theme.size.gap
    }
}
