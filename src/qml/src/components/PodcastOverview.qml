import QtQuick
import DynamicCast

Item {
    id: root

    property url    artworkSource:        ""
    property string podcastName:          ""
    property string author:               ""
    property string genre:                ""
    property real   rating:               0    // 0.0–5.0; 0 = unrated
    property int    ratingCount:          0
    property bool   following:            false
    property bool   notificationsEnabled: false
    property string description:          ""
    property string websiteUrl:           ""

    signal followClicked()
    signal unfollowClicked()
    signal notificationsToggled()
    signal websiteClicked()

    implicitHeight: mainCol.implicitHeight
    implicitWidth:  400

    function formatCount(n) {
        if (n >= 1000000) return (n / 1000000).toFixed(1).replace(/\.0$/, "") + "M"
        if (n >= 1000)    return (n / 1000).toFixed(1).replace(/\.0$/, "") + "k"
        return n.toString()
    }

    Column {
        id: mainCol
        anchors { left: parent.left; right: parent.right }
        spacing: 0

        // ── Artwork ───────────────────────────────────────────────────────────
        Item { width: 1; height: Theme.spaceLg }

        PodcastArtworkCard {
            anchors.horizontalCenter: parent.horizontalCenter
            width:  Theme.artworkSizeXl
            height: Theme.artworkSizeXl
            artworkSource: root.artworkSource
            podcastName:   root.podcastName
        }

        // ── Podcast name ──────────────────────────────────────────────────────
        Text {
            topPadding:   Theme.spaceLg
            leftPadding:  Theme.spaceLg
            rightPadding: Theme.spaceLg
            width: parent.width
            text: root.podcastName
            font.pixelSize: Theme.fontSizeH
            font.weight:    Theme.fontWeightBold
            font.family:    Theme.fontFamily
            color: Theme.textPrimary
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        // ── Author / genre ────────────────────────────────────────────────────
        Text {
            topPadding:   Theme.spaceSm
            leftPadding:  Theme.spaceLg
            rightPadding: Theme.spaceLg
            width: parent.width
            visible: root.author !== "" || root.genre !== ""
            text: {
                if (root.author !== "" && root.genre !== "")
                    return root.author + " · " + root.genre
                return root.author !== "" ? root.author : root.genre
            }
            font.pixelSize: Theme.fontSizeSm
            font.family:    Theme.fontFamily
            color: Theme.textSecondary
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        // ── Star rating ───────────────────────────────────────────────────────
        Column {
            width: parent.width
            visible: root.ratingCount > 0

            Item { width: 1; height: Theme.spaceSm }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 2

                Repeater {
                    model: 5
                    Text {
                        text: {
                            if (root.rating >= index + 1)   return ""  // star
                            if (root.rating >= index + 0.5) return ""  // star_half
                            return ""                                    // star_border
                        }
                        font.family:    "Material Icons"
                        font.pixelSize: Theme.iconSizeSm
                        color: root.rating > index ? Theme.warning : Theme.textDisabled
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    leftPadding: Theme.spaceXs
                    text: "(" + root.formatCount(root.ratingCount) + ")"
                    font.pixelSize: Theme.fontSizeSm
                    font.family:    Theme.fontFamily
                    color: Theme.textSecondary
                }
            }
        }

        // ── Action row ────────────────────────────────────────────────────────
        Column {
            width: parent.width

            Item { width: 1; height: Theme.spaceLg }

            // Large FOLLOW button — shown when not following
            Rectangle {
                anchors {
                    left:  parent.left;  leftMargin:  Theme.spaceLg
                    right: parent.right; rightMargin: Theme.spaceLg
                }
                visible: !root.following
                height:  48
                radius:  Theme.radiusFull
                color:   Theme.accent

                Text {
                    anchors.centerIn: parent
                    text: "FOLLOW"
                    font.pixelSize:    Theme.fontSizeSm
                    font.weight:       Theme.fontWeightBold
                    font.family:       Theme.fontFamily
                    font.letterSpacing: 1.5
                    color: Theme.textOnAccent
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { root.following = true; root.followClicked() }
                }
            }

            // Following state: check + bell icons
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: root.following
                spacing: Theme.spaceMd

                // Check — tap to unfollow
                Rectangle {
                    width: 44; height: 44
                    radius: Theme.radiusFull
                    color: "#4caf50"

                    Text {
                        anchors.centerIn: parent
                        text: ""   // check
                        font.family:    "Material Icons"
                        font.pixelSize: Theme.iconSizeSm
                        color: "#ffffff"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { root.following = false; root.unfollowClicked() }
                    }
                }

                // Notification bell
                Rectangle {
                    width: 44; height: 44
                    radius: Theme.radiusFull
                    color:        root.notificationsEnabled ? Theme.accent  : "transparent"
                    border.color: root.notificationsEnabled ? "transparent" : Theme.textDisabled
                    border.width: 1.5

                    Behavior on color        { ColorAnimation { duration: Theme.animNormal } }
                    Behavior on border.color { ColorAnimation { duration: Theme.animNormal } }

                    Text {
                        anchors.centerIn: parent
                        text: root.notificationsEnabled ? "" : ""   // notifications / notifications_none
                        font.family:    "Material Icons"
                        font.pixelSize: Theme.iconSizeSm
                        color: root.notificationsEnabled ? Theme.textOnAccent : Theme.textSecondary

                        Behavior on color { ColorAnimation { duration: Theme.animNormal } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.notificationsEnabled = !root.notificationsEnabled
                            root.notificationsToggled()
                        }
                    }
                }
            }
        }

        // ── Description ───────────────────────────────────────────────────────
        Column {
            id: descSection
            width: parent.width
            visible: root.description !== ""

            property bool expanded: false

            Item { width: 1; height: Theme.spaceLg }

            Text {
                id: descText
                leftPadding:  Theme.spaceLg
                rightPadding: Theme.spaceLg
                width: parent.width
                text: root.description
                font.pixelSize: Theme.fontSizeSm
                font.family:    Theme.fontFamily
                color: Theme.textSecondary
                wrapMode: Text.WordWrap
                lineHeight: 1.5
                maximumLineCount: descSection.expanded ? 100 : 3
                elide: Text.ElideRight
            }

            Text {
                leftPadding: Theme.spaceLg
                topPadding:  Theme.spaceXs
                visible: descText.truncated || descSection.expanded
                text: descSection.expanded ? "Read less" : "Read more"
                font.pixelSize: Theme.fontSizeSm
                font.family:    Theme.fontFamily
                font.weight:    Theme.fontWeightMedium
                color: Theme.accent

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -Theme.spaceXs
                    cursorShape: Qt.PointingHandCursor
                    onClicked: descSection.expanded = !descSection.expanded
                }
            }
        }

        // ── Website ───────────────────────────────────────────────────────────
        Column {
            width: parent.width
            visible: root.websiteUrl !== ""

            Item { width: 1; height: Theme.spaceSm }

            Item {
                width: parent.width
                height: websiteRow.implicitHeight + Theme.spaceXs * 2

                Row {
                    id: websiteRow
                    anchors {
                        left: parent.left
                        leftMargin: Theme.spaceLg
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: Theme.spaceXs

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: ""   // language (globe)
                        font.family:    "Material Icons"
                        font.pixelSize: Theme.iconSizeSm
                        color: Theme.accent
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.websiteUrl
                        font.pixelSize: Theme.fontSizeSm
                        font.family:    Theme.fontFamily
                        color: Theme.accent
                        font.underline: true
                        elide: Text.ElideRight
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.websiteClicked()
                        Qt.openUrlExternally(root.websiteUrl)
                    }
                }
            }
        }

        // ── Bottom padding ────────────────────────────────────────────────────
        Item { width: 1; height: Theme.spaceLg }
    }
}
