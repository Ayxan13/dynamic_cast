import QtQuick
import DynamicCast

Item {
    id: root

    property string podcastName: ""
    property string author: ""
    property url artworkSource
    property bool subscribed: false

    signal rowClicked()
    signal subscribeClicked()

    implicitHeight: Theme.miniPlayerHeight

    // Ripple / press feedback
    Rectangle {
        anchors.fill: parent
        color: Theme.bgRipple
        opacity: tapArea.pressed ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: Theme.animFast } }
    }

    MouseArea {
        id: tapArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.rowClicked()
    }

    // Artwork thumbnail
    Rectangle {
        id: artwork
        anchors {
            left: parent.left
            leftMargin: Theme.spaceMd
            verticalCenter: parent.verticalCenter
        }
        width: Theme.artworkSizeSm
        height: Theme.artworkSizeSm
        radius: Theme.radiusSm
        color: Theme.bgElevated
        clip: true

        Image {
            anchors.fill: parent
            source: root.artworkSource
            fillMode: Image.PreserveAspectCrop
            visible: root.artworkSource.toString() !== ""
        }

        // Placeholder icon
        Text {
            anchors.centerIn: parent
            text: "\ue3a1"   // music_note
            font.family: "Material Icons"
            font.pixelSize: Theme.iconSizeMd
            color: Theme.textDisabled
            visible: root.artworkSource.toString() === ""
        }
    }

    // Podcast name + author
    Column {
        anchors {
            left: artwork.right
            leftMargin: Theme.spaceMd
            right: subscribeBtn.left
            rightMargin: Theme.spaceSm
            verticalCenter: parent.verticalCenter
        }
        spacing: 3

        Text {
            width: parent.width
            text: root.podcastName
            font.pixelSize: Theme.fontSizeMd
            font.weight: Theme.fontWeightMedium
            font.family: Theme.fontFamily
            color: Theme.textPrimary
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            text: root.author
            font.pixelSize: Theme.fontSizeSm
            font.family: Theme.fontFamily
            color: Theme.textSecondary
            elide: Text.ElideRight
            visible: root.author !== ""
        }
    }

    // Subscribe button
    Item {
        id: subscribeBtn
        anchors {
            right: parent.right
            rightMargin: Theme.spaceSm
            verticalCenter: parent.verticalCenter
        }
        width: 44
        height: 44

        // Circle background — visible when subscribed
        Rectangle {
            anchors.centerIn: parent
            width: 32
            height: 32
            radius: Theme.radiusFull
            color: subscribed ? "#4caf50" : "transparent"
            border.color: root.subscribed ? "transparent" : Theme.textDisabled
            border.width: 1.5

            Behavior on color { ColorAnimation { duration: Theme.animNormal } }
            Behavior on border.color { ColorAnimation { duration: Theme.animNormal } }
        }

        Text {
            anchors.centerIn: parent
            text: root.subscribed ? "\ue876" : "\ue145"   // check / add
            font.family: "Material Icons"
            font.pixelSize: Theme.iconSizeSm
            color: root.subscribed ? "#ffffff" : Theme.textSecondary

            Behavior on color { ColorAnimation { duration: Theme.animNormal } }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.subscribeClicked()
        }
    }
}
