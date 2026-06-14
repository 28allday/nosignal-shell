pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia.Config
import qs.components
import qs.utils
import qs.modules.bar.popouts as BarPopouts

Item {
    id: root

    required property ShellScreen screen
    required property DrawerVisibilities visibilities
    required property BarPopouts.Wrapper popouts
    required property bool fullscreen

    readonly property bool disabled: Strings.testRegexList(Config.bar.excludedScreens, screen.name)

    // NoSignal horizontal top bar: the bar's "thickness" is its HEIGHT (was width
    // for the upstream vertical left-edge bar). clampedHeight/contentHeight and
    // implicitHeight carry the thickness; the wrapper fills the screen width.
    readonly property int clampedHeight: Math.max(Config.border.minThickness, implicitHeight)
    readonly property int padding: Math.max(Tokens.padding.small, Config.border.thickness)
    readonly property int contentHeight: Tokens.sizes.bar.innerWidth + padding * 2
    readonly property int exclusiveZone: !disabled && (Config.bar.persistent || visibilities.bar) ? contentHeight : Config.border.thickness
    // NoSignal redesign: the old caelestia bar is replaced by the slim NsBar
    // PanelWindow. Collapse it (the drawer engine is kept for launcher/OSD/lock).
    readonly property bool shouldBeVisible: false
    property bool isHovered

    function closeTray(): void {
        (content.item as Bar)?.closeTray();
    }

    function checkPopout(x: real): void {
        (content.item as Bar)?.checkPopout(x);
    }

    function handleWheel(x: real, angleDelta: point): void {
        (content.item as Bar)?.handleWheel(x, angleDelta);
    }

    clip: true
    visible: height > Config.border.thickness
    implicitHeight: fullscreen ? 0 : Config.border.thickness

    states: State {
        name: "visible"
        when: root.shouldBeVisible

        PropertyChanges {
            root.implicitHeight: root.contentHeight
        }
    }

    transitions: [
        Transition {
            from: ""
            to: "visible"

            Anim {
                target: root
                property: "implicitHeight"
            }
        },
        Transition {
            from: "visible"
            to: ""

            Anim {
                target: root
                property: "implicitHeight"
                type: Anim.Emphasized
            }
        }
    ]

    Loader {
        id: content

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        active: root.shouldBeVisible

        sourceComponent: Bar {
            height: root.contentHeight
            screen: root.screen
            visibilities: root.visibilities
            popouts: root.popouts // qmllint disable incompatible-type
            fullscreen: root.fullscreen
        }
    }
}
