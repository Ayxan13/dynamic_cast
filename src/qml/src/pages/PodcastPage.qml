import QtQuick
import QtQuick.Controls
import DynamicCast

Item {
    id: root

    // ── PodcastOverview forwarded props ───────────────────────────────────────
    property url    artworkSource:        ""
    property string podcastName:          ""
    property string author:               ""
    property string genre:                ""
    property real   rating:               0
    property int    ratingCount:          0
    property bool   following:            false
    property bool   notificationsEnabled: false
    property string description:          ""
    property string websiteUrl:           ""

    // ── Episode list ──────────────────────────────────────────────────────────
    // Each element: { episodeNumber, releaseDate, title, durationMinutes,
    //                 progress, playing, archived }
    property var episodes: []

    // ── Signals ───────────────────────────────────────────────────────────────
    signal backClicked()
    signal castClicked()
    signal shareClicked()
    signal episodePlayPauseClicked(int index)
    signal followClicked()
    signal unfollowClicked()
    signal notificationsToggled()
    signal websiteClicked()

    // ── Internal state ────────────────────────────────────────────────────────
    property bool   showArchived: false
    property string _searchText:  ""

    readonly property int archivedCount: {
        var n = 0
        for (var i = 0; i < episodes.length; i++)
            if (episodes[i].archived) n++
        return n
    }

    readonly property var filteredEpisodes: {
        var f = root._searchText.toLowerCase()
        var result = []
        for (var i = 0; i < episodes.length; i++) {
            var ep = episodes[i]
            if (ep.archived && !root.showArchived) continue
            if (f !== "" && ep.title.toLowerCase().indexOf(f) === -1) continue
            result.push(ep)
        }
        return result
    }

    // ── Header bar ────────────────────────────────────────────────────────────
    Rectangle {
        id: pageHeader
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 56
        color: Theme.bgSurface
        z: 1

        Item {
            anchors { left: parent.left; leftMargin: Theme.spaceXs; verticalCenter: parent.verticalCenter }
            width: 44; height: 44

            Text {
                anchors.centerIn: parent
                text: ""   // arrow_back
                font.family:    "Material Icons"
                font.pixelSize: Theme.iconSizeMd
                color: Theme.textPrimary
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.backClicked()
            }
        }

        Row {
            anchors { right: parent.right; rightMargin: Theme.spaceXs; verticalCenter: parent.verticalCenter }

            Item {
                width: 44; height: 44

                Text {
                    anchors.centerIn: parent
                    text: ""   // cast
                    font.family:    "Material Icons"
                    font.pixelSize: Theme.iconSizeMd
                    color: Theme.textPrimary
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.castClicked()
                }
            }

            Item {
                width: 44; height: 44

                Text {
                    anchors.centerIn: parent
                    text: ""   // share
                    font.family:    "Material Icons"
                    font.pixelSize: Theme.iconSizeMd
                    color: Theme.textPrimary
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.shareClicked()
                }
            }
        }

        Rectangle {
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
            height: 1
            color: Theme.divider
        }
    }

    // ── Scrollable content ────────────────────────────────────────────────────
    Flickable {
        id: scroller
        anchors {
            top: pageHeader.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        contentHeight: pageCol.implicitHeight
        clip: true

        Column {
            id: pageCol
            width: scroller.width
            spacing: 0

            // ── Podcast overview ──────────────────────────────────────────────
            PodcastOverview {
                width: parent.width
                artworkSource:        root.artworkSource
                podcastName:          root.podcastName
                author:               root.author
                genre:                root.genre
                rating:               root.rating
                ratingCount:          root.ratingCount
                following:            root.following
                notificationsEnabled: root.notificationsEnabled
                description:          root.description
                websiteUrl:           root.websiteUrl
                onFollowClicked:        root.followClicked()
                onUnfollowClicked:      root.unfollowClicked()
                onNotificationsToggled: root.notificationsToggled()
                onWebsiteClicked:       root.websiteClicked()
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider }

            // ── Episode search bar ────────────────────────────────────────────
            Item {
                width: parent.width
                height: 44 + Theme.spaceMd * 2

                SearchBar {
                    anchors.centerIn: parent
                    width: parent.width - Theme.spaceLg * 2
                    placeholder: "Search episodes…"
                    onTextChanged: root._searchText = text
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider }

            // ── Info bar ──────────────────────────────────────────────────────
            Item {
                width: parent.width
                height: 44

                Text {
                    anchors { left: parent.left; leftMargin: Theme.spaceMd; verticalCenter: parent.verticalCenter }
                    text: {
                        var t = root.episodes.length + " episode" + (root.episodes.length !== 1 ? "s" : "")
                        if (root.archivedCount > 0)
                            t += " · " + root.archivedCount + " archived"
                        return t
                    }
                    font.pixelSize: Theme.fontSizeXs
                    font.family:    Theme.fontFamily
                    color: Theme.textSecondary
                }

                Item {
                    id: archivedToggle
                    anchors { right: parent.right; rightMargin: Theme.spaceSm; verticalCenter: parent.verticalCenter }
                    visible: root.archivedCount > 0
                    height: 28
                    width: archivedLabel.implicitWidth + Theme.spaceMd * 2

                    Rectangle {
                        anchors.fill: parent
                        radius: Theme.radiusFull
                        color:        root.showArchived ? Theme.accent  : "transparent"
                        border.color: root.showArchived ? "transparent" : Theme.textDisabled
                        border.width: 1

                        Behavior on color        { ColorAnimation { duration: Theme.animFast } }
                        Behavior on border.color { ColorAnimation { duration: Theme.animFast } }
                    }

                    Text {
                        id: archivedLabel
                        anchors.centerIn: parent
                        text: root.showArchived ? "Hide Archived" : "Show Archived"
                        font.pixelSize: Theme.fontSizeXs
                        font.weight:    Theme.fontWeightMedium
                        font.family:    Theme.fontFamily
                        color: root.showArchived ? Theme.textOnAccent : Theme.textSecondary

                        Behavior on color { ColorAnimation { duration: Theme.animFast } }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.showArchived = !root.showArchived
                    }
                }

                Rectangle {
                    anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
                    height: 1
                    color: Theme.divider
                }
            }

            // ── Episode list ──────────────────────────────────────────────────
            Repeater {
                model: root.filteredEpisodes

                EpisodeListItem {
                    width: pageCol.width
                    episodeNumber:   modelData.episodeNumber   ?? -1
                    releaseDate:     modelData.releaseDate     ?? ""
                    episodeTitle:    modelData.title           ?? ""
                    durationMinutes: modelData.durationMinutes ?? -1
                    progress:        modelData.progress        ?? 0.0
                    playing:         modelData.playing         ?? false
                    archived:        modelData.archived        ?? false
                    onPlayPauseClicked: root.episodePlayPauseClicked(index)
                }
            }

            // ── Empty state ───────────────────────────────────────────────────
            Item {
                width: parent.width
                height: root.filteredEpisodes.length === 0 && root.episodes.length > 0 ? 120 : 0
                visible: height > 0

                Column {
                    anchors.centerIn: parent
                    spacing: Theme.spaceSm
                    visible: parent.visible

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: ""   // search
                        font.family:    "Material Icons"
                        font.pixelSize: Theme.iconSizeXl
                        color: Theme.textDisabled
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: root._searchText !== ""
                              ? "No episodes match your search"
                              : "No episodes to show.\nTap 'Show Archived' to view archived episodes."
                        font.pixelSize: Theme.fontSizeSm
                        font.family:    Theme.fontFamily
                        color: Theme.textSecondary
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                        width: 260
                    }
                }
            }

            Item { width: 1; height: Theme.spaceLg }
        }

        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
    }
}
