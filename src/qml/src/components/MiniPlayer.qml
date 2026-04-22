import QtQuick
import QtQuick.Controls
import DynamicCast

Rectangle {
    id: root

    property string title: ""
    property string podcastName: ""
    property url artworkSource
    property real position: 0.0   // 0.0 – 1.0
    property bool playing: false
    property bool buffering: false

    signal playPauseClicked()
    signal skipForwardClicked()
    signal tapped()

    height: Theme.miniPlayerHeight
    color: Theme.bgSurface

    // Top border
    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 1
        color: Theme.divider
    }

    // Progress bar along the bottom edge
    Rectangle {
        anchors {
            bottom: parent.bottom
            left: parent.left
        }
        height: 2
        width: parent.width * Math.max(0, Math.min(1, root.position))
        color: Theme.progressFill

        Behavior on width {
            NumberAnimation { duration: Theme.animFast }
        }
    }

    // Tap anywhere (except buttons) to open full player
    MouseArea {
        anchors.fill: parent
        onClicked: root.tapped()
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
            text: ""   // music_note
            font.family: "Material Icons"
            font.pixelSize: Theme.iconSizeMd
            color: Theme.textDisabled
            visible: root.artworkSource.toString() === ""
        }
    }

    // Episode title + podcast name
    Column {
        anchors {
            left: artwork.right
            leftMargin: Theme.spaceMd
            right: controls.left
            rightMargin: Theme.spaceSm
            verticalCenter: parent.verticalCenter
        }
        spacing: 2

        Text {
            width: parent.width
            text: root.title
            font.pixelSize: Theme.fontSizeMd
            font.weight: Theme.fontWeightMedium
            font.family: Theme.fontFamily
            color: Theme.textPrimary
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            text: root.podcastName
            font.pixelSize: Theme.fontSizeSm
            font.family: Theme.fontFamily
            color: Theme.textSecondary
            elide: Text.ElideRight
        }
    }

    // Play/Pause + Skip-forward buttons
    Row {
        id: controls
        anchors {
            right: parent.right
            rightMargin: Theme.spaceSm
            verticalCenter: parent.verticalCenter
        }

        // Play / Pause
        Item {
            width: 44
            height: 44

            Text {
                anchors.centerIn: parent
                text: root.playing ? "" : ""   // pause / play_arrow
                font.family: "Material Icons"
                font.pixelSize: Theme.iconSizeLg
                color: Theme.textPrimary
            }

            Loader {
                anchors.centerIn: parent
                width: Theme.iconSizeLg
                height: Theme.iconSizeLg
                active: root.buffering
                sourceComponent: BusyIndicator {
                    anchors.fill: parent
                    running: true
                    padding: 0
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.playPauseClicked()
            }
        }

        // Skip forward 30 s
        Item {
            width: 44
            height: 44

            Text {
                anchors.centerIn: parent
                text: ""   // fast_forward
                font.family: "Material Icons"
                font.pixelSize: Theme.iconSizeMd
                color: Theme.textPrimary
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.skipForwardClicked()
            }
        }
    }
}
