import QtQuick
import QtQuick.Controls
import DynamicCast

Rectangle {
    id: root
    color: Theme.bgBase

    // ── Feed source ───────────────────────────────────────────────────────────
    property string feedUrl: ""

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
    property bool   showArchived:  false
    property bool   _reverseOrder: false
    property string _searchText:   ""
    property bool   _feedLoading:  false
    property bool   _feedReady:    false
    property string _feedError:    ""

    // ── Feed fetch ────────────────────────────────────────────────────────────
    function parseDurationMinutes(str) {
        if (!str || str === "") return -1
        var parts = str.split(":")
        if (parts.length === 3) return parseInt(parts[0]) * 60 + parseInt(parts[1])
        if (parts.length === 2) return parseInt(parts[0])
        var secs = parseInt(str)
        if (!isNaN(secs) && secs > 0) return Math.floor(secs / 60)
        return -1
    }

    onFeedUrlChanged: {
        if (feedUrl === "") return
        root._feedLoading = true
        root._feedReady   = false
        root._feedError   = ""
        feedController.fetch(feedUrl).then(function(feed) {
            root._feedLoading = false
            if (!feed || feed.title === "") return
            root.podcastName   = feed.title
            root.author        = feed.hosts
            root.description   = feed.description
            root.artworkSource = feed.imageUrl !== "" ? Qt.url(feed.imageUrl) : root.artworkSource
            root.genre         = feed.primaryGenre
            root.websiteUrl    = feed.link
            var eps = []
            for (var i = 0; i < feed.episodes.length; i++) {
                var ep = feed.episodes[i]
                eps.push({
                    episodeNumber:   ep.episodeNumber,
                    title:           ep.title,
                    releaseDate:     ep.pubDate,
                    durationMinutes: root.parseDurationMinutes(ep.duration),
                    audioUrl:        ep.audioUrl,
                    progress:        0,
                    archived:        false
                })
            }
            root.episodes  = eps
            root._feedReady = true
        })
    }

    Connections {
        target: feedController
        function onFetchFailed(error) {
            root._feedLoading = false
            root._feedError   = error
        }
    }

    // ── Derived lists ─────────────────────────────────────────────────────────
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
        if (root._reverseOrder) result.reverse()
        return result
    }

    // ── Header bar (always visible) ───────────────────────────────────────────
    Rectangle {
        id: pageHeader
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: 56
        color: Theme.bgSurface
        z: 2

        // Back button
        Item {
            anchors { left: parent.left; leftMargin: Theme.spaceXs; verticalCenter: parent.verticalCenter }
            width: 44; height: 44

            Text {
                anchors.centerIn: parent
                text: ""   // arrow_back
                font.family:    "Material Icons"
                font.pixelSize: Theme.iconSizeMd
                color: Theme.textPrimary
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: AppNavigation.pop()
            }
        }

        // Cast + Share buttons
        Row {
            anchors { right: parent.right; rightMargin: Theme.spaceXs; verticalCenter: parent.verticalCenter }

            Item {
                width: 44; height: 44

                Text {
                    anchors.centerIn: parent
                    text: ""   // cast
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
                    text: ""   // share
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

    // ── Loading spinner (fills space below header) ────────────────────────────
    Item {
        anchors { top: pageHeader.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        visible: root._feedLoading && !root._feedReady

        BusyIndicator {
            anchors.centerIn: parent
            running: parent.visible
        }
    }

    // ── Error state ───────────────────────────────────────────────────────────
    Item {
        anchors { top: pageHeader.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        visible: !root._feedLoading && root._feedError !== ""

        Column {
            anchors.centerIn: parent
            spacing: Theme.spaceSm

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: ""   // error_outline
                font.family:    "Material Icons"
                font.pixelSize: Theme.iconSizeXl
                color: Theme.error
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Failed to load feed"
                font.pixelSize: Theme.fontSizeMd
                font.family:    Theme.fontFamily
                font.weight:    Theme.fontWeightMedium
                color: Theme.textSecondary
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root._feedError
                font.pixelSize: Theme.fontSizeXs
                font.family:    Theme.fontFamily
                color: Theme.textDisabled
                wrapMode: Text.WordWrap
                width: 260
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // ── Scrollable content (hidden until feed is ready) ───────────────────────
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
        visible: root._feedReady

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

                // Episode count
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

                // Right-side controls: sort + archived toggle
                Row {
                    anchors { right: parent.right; rightMargin: Theme.spaceSm; verticalCenter: parent.verticalCenter }
                    spacing: Theme.spaceXs

                    // Sort-order toggle
                    Item {
                        width: 32; height: 32

                        Text {
                            anchors.centerIn: parent
                            text: ""   // sort
                            font.family:    "Material Icons"
                            font.pixelSize: Theme.iconSizeSm
                            color: root._reverseOrder ? Theme.accent : Theme.textSecondary

                            Behavior on color { ColorAnimation { duration: Theme.animFast } }

                            rotation: root._reverseOrder ? 180 : 0
                            Behavior on rotation { NumberAnimation { duration: Theme.animFast } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root._reverseOrder = !root._reverseOrder
                        }
                    }

                    // Archived toggle
                    Item {
                        id: archivedToggle
                        visible: root.archivedCount > 0
                        height: 28
                        width: visible ? archivedLabel.implicitWidth + Theme.spaceMd * 2 : 0

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
                    archived:        modelData.archived        ?? false
                    playing: audioPlayer.playing && audioPlayer.episodeUrl === (modelData.audioUrl ?? "")
                    buffering: audioPlayer.buffering && audioPlayer.episodeUrl === (modelData.audioUrl ?? "")
                    progress: audioPlayer.episodeUrl === (modelData.audioUrl ?? "")
                              ? audioPlayer.position
                              : (modelData.progress ?? 0.0)
                    onPlayPauseClicked: {
                        var ep = root.filteredEpisodes[index]
                        if (!ep) return
                        if (audioPlayer.episodeUrl === ep.audioUrl && audioPlayer.playing)
                            audioPlayer.togglePlayPause()
                        else
                            audioPlayer.playEpisode(ep.audioUrl ?? "", ep.title ?? "",
                                                    root.podcastName, root.artworkSource)
                    }
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
                        text: ""   // search
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
