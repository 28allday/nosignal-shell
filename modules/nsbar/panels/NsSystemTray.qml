pragma ComponentBehavior: Bound

// NoSignal System Tray popout (off the tray pill). Grid of StatusNotifierItems;
// left-click activates, right-click opens the item's menu. Uses SystemTray.

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import qs.services
import qs.components

NsPanel {
    id: root

    implicitWidth: 260
    anchorMode: "right"

    StyledText {
        text: "System Tray"
        color: Theme.text
        font.family: Theme.font.family
        font.pixelSize: Theme.font.panelTitle
        font.weight: Font.DemiBold
    }

    GridLayout {
        Layout.fillWidth: true
        columns: 4
        rowSpacing: 8
        columnSpacing: 8
        visible: SystemTray.items.values.length > 0

        Repeater {
            model: SystemTray.items

            delegate: ColumnLayout {
                id: cell

                required property var modelData

                Layout.alignment: Qt.AlignHCenter
                spacing: 4

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: 44
                    implicitHeight: 44
                    radius: Theme.radius.tile
                    color: cellMa.containsMouse ? Theme.hover : Theme.fillSubtle

                    Image {
                        anchors.centerIn: parent
                        width: 22
                        height: 22
                        source: cell.modelData?.icon ?? ""
                        sourceSize.width: 44
                        sourceSize.height: 44
                        fillMode: Image.PreserveAspectFit
                    }

                    MouseArea {
                        id: cellMa
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        cursorShape: Qt.PointingHandCursor
                        onClicked: mouse => {
                            if (mouse.button === Qt.RightButton)
                                cell.modelData?.display(cell, 0, height);
                            else if (cell.modelData?.onlyMenu)
                                cell.modelData?.display(cell, 0, height);
                            else
                                cell.modelData?.activate();
                        }
                    }
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: 50
                    text: cell.modelData?.title || cell.modelData?.id || ""
                    color: Theme.textMuted
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    font.family: Theme.font.family
                    font.pixelSize: Theme.font.meta
                }
            }
        }
    }

    StyledText {
        visible: SystemTray.items.values.length === 0
        text: "No tray items"
        color: Theme.textMuted
        font.family: Theme.font.family
        font.pixelSize: Theme.font.bodySmall
    }
}
