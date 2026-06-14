pragma Singleton
pragma ComponentBehavior: Bound

// NoSignal design-system tokens (interface redesign 2026-06-14).
// Fixed dark-glass chrome + text, but the ACCENT is Material You (wallpaper-
// derived) per the user's choice. Components in the redesigned bar/panels read
// from here instead of hard-coding hex values. See the design handoff README.
//
// NB: the "backdrop blur" in the spec is done at the compositor level (Hyprland
// layerrules blur on the shell namespaces), not in QML — these fills are the
// translucent surface colours that sit over that blur.

import QtQuick
import Quickshell
import qs.services

Singleton {
    id: root

    // ── Accent: Material You, dynamic from wallpaper ──────────────────────
    readonly property color accent: Colours.palette.m3primary
    readonly property color onAccent: Colours.palette.m3onPrimary // contrasting text/icon on accent fills
    // accent.soft — translucent accent for active-module bg / selected rows
    readonly property color accentSoft: Qt.alpha(accent, 0.15)
    readonly property color accentSofter: Qt.alpha(accent, 0.13)

    // ── Secondary semantic accents (fixed) ───────────────────────────────
    readonly property color blue: "#8FB5D6"   // avatar gradient, event tint
    readonly property color green: "#86C09A"  // now-playing tint
    readonly property color danger: "#E0746A" // power button + Shut Down

    // ── Surfaces: fixed dark glass ───────────────────────────────────────
    readonly property color barBg: Qt.rgba(15 / 255, 18 / 255, 24 / 255, 0.60)
    readonly property color barBorder: Qt.rgba(1, 1, 1, 0.06)
    readonly property color panelBg: Qt.rgba(17 / 255, 20 / 255, 26 / 255, 0.90)
    readonly property color panelBorder: Qt.rgba(1, 1, 1, 0.09)
    readonly property color overlayBg: Qt.rgba(8 / 255, 10 / 255, 14 / 255, 0.82)

    // panel drop shadow + inset highlight
    readonly property color shadow: Qt.rgba(0, 0, 0, 0.55)
    readonly property color insetHighlight: Qt.rgba(1, 1, 1, 0.05)

    // ── Text (fixed) ─────────────────────────────────────────────────────
    readonly property color text: Qt.rgba(233 / 255, 238 / 255, 243 / 255, 0.92)
    readonly property color textMuted: Qt.rgba(233 / 255, 238 / 255, 243 / 255, 0.50)
    readonly property color textFaint: Qt.rgba(233 / 255, 238 / 255, 243 / 255, 0.34)

    // ── Fills / states (fixed) ───────────────────────────────────────────
    readonly property color hover: Qt.rgba(1, 1, 1, 0.07)
    readonly property color fillSubtle: Qt.rgba(1, 1, 1, 0.05)

    // ── Typography ───────────────────────────────────────────────────────
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property QtObject font: QtObject {
        readonly property string family: root.fontFamily
        readonly property int bar: 12
        readonly property int panelTitle: 13
        readonly property int body: 12
        readonly property int bodySmall: 11
        readonly property int label: 10        // section labels (uppercase, tracked)
        readonly property int meta: 10         // times, %, device sub
        readonly property int clockBig: 52     // power-menu clock
        readonly property real trackingLabel: 1.6
        readonly property real trackingBar: -0.1
        readonly property real trackingClockBig: 2
    }

    // ── Shape ────────────────────────────────────────────────────────────
    // NoSignal: no curved corners anywhere — all rectangular elements are square.
    readonly property QtObject radius: QtObject {
        readonly property int panel: 0
        readonly property int button: 0
        readonly property int barModule: 0
        readonly property int tile: 0
        readonly property int full: 1000    // genuine circles only (toggle icons, avatar, switch knob)
    }

    // ── Spacing / sizing ─────────────────────────────────────────────────
    readonly property QtObject size: QtObject {
        readonly property int barHeight: 38       // exclusive zone
        readonly property int popoutTopRight: 44  // right-anchored panels
        readonly property int popoutTopCenter: 48 // centered panels
        readonly property int panelPad: 16        // 14-18
        readonly property int gap: 12             // 8-16
        readonly property int rowMin: 30          // panel row hit target
        readonly property int barIcon: 16         // 15-17
    }

    // ── Animation ────────────────────────────────────────────────────────
    readonly property int hoverMs: 120
}
