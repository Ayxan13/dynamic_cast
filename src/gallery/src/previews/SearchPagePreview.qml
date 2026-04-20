import QtQuick
import DynamicCast

// Preview of SearchPage in a phone-sized frame
Item {
    Rectangle {
        anchors.centerIn: parent
        width: 400
        height: 600
        color: Theme.bgBase
        clip: true
        radius: Theme.radiusMd

        // Phone frame border
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: Theme.divider
            border.width: 1
            radius: parent.radius
            z: 1
        }

        SearchPage {
            anchors.fill: parent
        }
    }
}
