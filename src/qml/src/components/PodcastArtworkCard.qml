import QtQuick
import DynamicCast

Item {
    id: root

    property url artworkSource: ""
    property string podcastName: ""
    property color placeholderColor: Theme.bgElevated

    implicitWidth: 80
    implicitHeight: 80

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusMd
        color: root.artworkSource != "" ? "transparent" : root.placeholderColor
        clip: true

        Image {
            anchors.fill: parent
            source: root.artworkSource
            fillMode: Image.PreserveAspectCrop
            visible: root.artworkSource != ""
        }

        // Fallback: first letter of podcast name
        Text {
            anchors.centerIn: parent
            visible: root.artworkSource == ""
            text: root.podcastName.charAt(0).toUpperCase()
            font.pixelSize: Theme.fontSizeH
            font.weight: Theme.fontWeightBold
            font.family: Theme.fontFamily
            color: Qt.rgba(1, 1, 1, 0.6)
        }
    }
}
