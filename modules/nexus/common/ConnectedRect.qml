import QtQuick
import Caelestia.Config
import qs.components
import qs.services

StyledRect {
    property bool first
    property bool last

    // NoSignal: dark-glass cards, 4px outer corners (connected-list look)
    color: Theme.fillSubtle
    topLeftRadius: first ? Theme.radius.panel : 0
    topRightRadius: first ? Theme.radius.panel : 0
    bottomLeftRadius: last ? Theme.radius.panel : 0
    bottomRightRadius: last ? Theme.radius.panel : 0
}
