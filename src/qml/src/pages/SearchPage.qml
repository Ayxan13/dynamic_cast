import QtQuick
import QtQuick.Controls
import DynamicCast

Item {
    id: root

    // ── State ─────────────────────────────────────────────────────────────────
    // "idle"    — no query, show discovery prompt
    // "typing"  — text changed, debounce running
    // "loading" — debounce fired, awaiting results
    // "results" — results present
    // "empty"   — search done, nothing found
    // "error"   — search failed
    readonly property string state_: {
        if (searchBar.text.trim().length === 0) return "idle"
        if (debounce.running)                   return "typing"
        if (searchController.loading)           return "loading"
        if (errorMessage.length > 0)            return "error"
        if (resultsModel.count > 0)             return "results"
        return "empty"
    }

    property string lastQuery: ""
    property string errorMessage: ""

    function openPodcast(feedUrl, name, artworkUrl, author) {
        AppNavigation.push("pages/PodcastPage.qml", {
            feedUrl:      feedUrl,
            podcastName:  name,
            artworkSource: artworkUrl !== "" ? Qt.url(artworkUrl) : "",
            author:       author
        })
    }

    // ── Debounce timer ────────────────────────────────────────────────────────
    Timer {
        id: debounce
        interval: 500
        repeat: false
        onTriggered: {
            const q = searchBar.text.trim()
            if (q.length === 0) return
            root.lastQuery = q
            root.errorMessage = ""
            resultsModel.clear()
            searchController.search(q).then(function(results) {
                resultsModel.clear()
                for (const r of results) {
                    resultsModel.append({
                        podcastName: r.podcastName,
                        author:      r.author,
                        artworkUrl:  r.artworkUrl,
                        rssUrl:      r.rssUrl,
                        subscribed:  false
                    })
                }
            })
        }
    }

    Connections {
        target: searchController

        function onSearchFailed(error) {
            root.errorMessage = error
        }
    }

    ListModel { id: resultsModel }

    // ── Layout ────────────────────────────────────────────────────────────────
    SearchBar {
        id: searchBar
        anchors {
            top: parent.top
            topMargin: Theme.spaceMd
            left: parent.left
            leftMargin: Theme.spaceMd
            right: parent.right
            rightMargin: Theme.spaceMd
        }
        placeholder: "Search podcasts…"

        onTextChanged: {
            resultsModel.clear()
            root.errorMessage = ""
            debounce.restart()
        }

        Component.onCompleted: forceActiveFocus()
    }

    Item {
        anchors {
            top: searchBar.bottom
            topMargin: Theme.spaceMd
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        // ── Idle placeholder ─────────────────────────────────────────────
        Column {
            anchors.centerIn: parent
            spacing: Theme.spaceSm
            visible: root.state_ === "idle"
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.animFast } }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "\ue8b6" // podcast icon
                font.family: "Material Icons"
                font.pixelSize: Theme.iconSizeXl
                color: Theme.textDisabled
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Discover podcasts"
                font.pixelSize: Theme.fontSizeLg
                font.family: Theme.fontFamily
                font.weight: Theme.fontWeightMedium
                color: Theme.textSecondary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Search by title, host, or topic"
                font.pixelSize: Theme.fontSizeSm
                font.family: Theme.fontFamily
                color: Theme.textDisabled
            }
        }

        // ── Loading spinner ──────────────────────────────────────────────
        Column {
            anchors.centerIn: parent
            spacing: Theme.spaceMd
            visible: root.state_ === "loading"
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.animFast } }

            BusyIndicator {
                anchors.horizontalCenter: parent.horizontalCenter
                running: root.state_ === "loading"
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Searching…"
                font.pixelSize: Theme.fontSizeSm
                font.family: Theme.fontFamily
                color: Theme.textDisabled
            }
        }

        // ── Empty state ──────────────────────────────────────────────────
        Column {
            anchors.centerIn: parent
            spacing: Theme.spaceSm
            visible: root.state_ === "empty"
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.animFast } }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "\ue5c9" // cancel icon
                font.family: "Material Icons"
                font.pixelSize: Theme.iconSizeXl
                color: Theme.textDisabled
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "No results for \"%1\"".arg(root.lastQuery)
                font.pixelSize: Theme.fontSizeMd
                font.family: Theme.fontFamily
                color: Theme.textSecondary
            }
        }

        // ── Error state ──────────────────────────────────────────────────
        Column {
            anchors.centerIn: parent
            spacing: Theme.spaceSm
            visible: root.state_ === "error"
            opacity: visible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Theme.animFast } }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "\ue000"  // error_outline
                font.family: "Material Icons"
                font.pixelSize: Theme.iconSizeXl
                color: Theme.error
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Search failed"
                font.pixelSize: Theme.fontSizeMd
                font.family: Theme.fontFamily
                font.weight: Theme.fontWeightMedium
                color: Theme.textSecondary
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.errorMessage
                font.pixelSize: Theme.fontSizeXs
                font.family: Theme.fontFamily
                color: Theme.textDisabled
            }
        }

        // ── Results list ─────────────────────────────────────────────────
        ListView {
            id: resultsList
            anchors.fill: parent
            model: resultsModel
            clip: true
            visible: root.state_ === "results"

            add: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.animFast }
                NumberAnimation { property: "y"; from: 8; duration: Theme.animFast; easing.type: Easing.OutCubic }
            }

            delegate: Column {
                width: resultsList.width
                spacing: 0

                PodcastResultRow {
                    width: parent.width
                    podcastName: model.podcastName
                    author:      model.author
                    artworkSource: model.artworkUrl !== "" ? Qt.url(model.artworkUrl) : ""
                    subscribed:  model.subscribed
                    onSubscribeClicked: resultsModel.setProperty(index, "subscribed", !model.subscribed)
                    onRowClicked: root.openPodcast(model.rssUrl, model.podcastName, model.artworkUrl, model.author)
                }

                Rectangle {
                    visible: index < resultsModel.count - 1
                    width: parent.width
                    height: 1
                    color: Theme.divider
                }
            }

            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
        }
    }
}
