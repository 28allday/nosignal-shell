pragma ComponentBehavior: Bound

// NoSignal Audio Mixer popout (off the volume pill). Output device row, master
// slider, per-app application sliders, input (mic) slider. Wired to Pipewire
// via the Audio service.

import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components

NsPanel {
    id: root

    implicitWidth: 340
    anchorMode: "right"

    // output device
    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        NsIcon {
            icon: "speaker"
            color: Theme.textMuted
        }

        StyledText {
            Layout.fillWidth: true
            text: Audio.sink?.description || Audio.sink?.name || "Output"
            color: Theme.text
            elide: Text.ElideRight
            font.family: Theme.font.family
            font.pixelSize: Theme.font.bodySmall
        }

        NsIcon {
            icon: "expand_more"
            color: Theme.textFaint
        }
    }

    AudioSlider {
        icon: Audio.muted ? "volume_off" : "volume_up"
        value: Audio.volume
        onMoved: v => Audio.setVolume(v)
    }

    // applications
    StyledText {
        visible: Audio.streams.length > 0
        text: "APPLICATIONS"
        color: Theme.textFaint
        font.family: Theme.font.family
        font.pixelSize: Theme.font.label
        font.letterSpacing: Theme.font.trackingLabel
    }

    Repeater {
        model: Audio.streams

        delegate: AudioSlider {
            required property var modelData

            Layout.fillWidth: true
            icon: "graphic_eq"
            label: modelData?.properties?.["application.name"] || modelData?.description || modelData?.name || "App"
            value: modelData?.audio?.volume ?? 0
            onMoved: v => {
                if (modelData?.audio)
                    modelData.audio.volume = v;
            }
        }
    }

    // input
    StyledText {
        text: "INPUT"
        Layout.topMargin: 2
        color: Theme.textFaint
        font.family: Theme.font.family
        font.pixelSize: Theme.font.label
        font.letterSpacing: Theme.font.trackingLabel
    }

    AudioSlider {
        icon: Audio.sourceMuted ? "mic_off" : "mic"
        value: Audio.sourceVolume
        onMoved: v => Audio.setSourceVolume(v)
    }

    component AudioSlider: ColumnLayout {
        id: s

        property string icon
        property string label: ""
        property real value: 0
        signal moved(real v)

        Layout.fillWidth: true
        spacing: 3

        StyledText {
            visible: s.label !== ""
            text: s.label
            color: Theme.textMuted
            elide: Text.ElideRight
            Layout.fillWidth: true
            font.family: Theme.font.family
            font.pixelSize: Theme.font.meta
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            NsIcon {
                icon: s.icon
                color: Theme.textMuted
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 6
                radius: 0
                color: Theme.fillSubtle

                Rectangle {
                    width: parent.width * Math.max(0, Math.min(1, s.value))
                    height: parent.height
                    radius: 0
                    color: Theme.accent
                }

                Rectangle {
                    x: parent.width * Math.max(0, Math.min(1, s.value)) - width / 2
                    anchors.verticalCenter: parent.verticalCenter
                    implicitWidth: 14
                    implicitHeight: 14
                    radius: 0
                    color: Theme.accent
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: e => s.moved(Math.max(0, Math.min(1, e.x / width)))
                    onPositionChanged: e => {
                        if (pressed)
                            s.moved(Math.max(0, Math.min(1, e.x / width)));
                    }
                }
            }

            StyledText {
                text: Math.round(s.value * 100) + "%"
                color: Theme.textMuted
                font.family: Theme.font.family
                font.pixelSize: Theme.font.meta
            }
        }
    }
}
