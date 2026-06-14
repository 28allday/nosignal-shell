pragma ComponentBehavior: Bound

// NoSignal icon: renders a Nerd Font (JetBrainsMono NF) glyph from a Material
// Symbol name via the Glyphs map. Drop-in for MaterialIcon but the input is
// `icon` (the name) instead of `text`, so dynamic bindings stay reactive.

import QtQuick
import qs.services

Text {
    id: root

    property string icon: ""
    property int size: 16
    // MaterialIcon API parity so NsIcon is a drop-in (these are no-ops here —
    // Nerd Font has no fill/grade variable axes; sizing comes from fontStyle).
    property real fill: 0
    property int grade: 0
    property bool animate: false
    property var fontStyle: null

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    text: Glyphs.get(root.icon)
    // "Mono" variant centers each icon glyph in a fixed cell (the plain NF
    // variant uses a wide advance, which left/right-shifts centered icons).
    font.family: "JetBrainsMono Nerd Font Mono"
    font.pixelSize: root.fontStyle ? (root.fontStyle.pixelSize > 0 ? root.fontStyle.pixelSize : Math.round((root.fontStyle.pointSize || 12) * 1.33)) : root.size
    color: Theme.text
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
