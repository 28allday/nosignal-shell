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
    property real fill: 0 // API parity with MaterialIcon (unused for Nerd Font)

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    text: Glyphs.get(root.icon)
    // "Mono" variant centers each icon glyph in a fixed cell (the plain NF
    // variant uses a wide advance, which left/right-shifts centered icons).
    font.family: "JetBrainsMono Nerd Font Mono"
    font.pixelSize: root.size
    color: Theme.text
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
