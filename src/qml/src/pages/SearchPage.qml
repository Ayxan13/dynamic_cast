import QtQuick
import QtQuick.Controls
import DynamicCast

Item {
    id: root

    // ── State ─────────────────────────────────────────────────────────────────
    // "idle"    — no query, show discovery prompt
    // "typing"  — text changed, debounce running, results cleared (blank)
    // "loading" — debounce fired, awaiting results
    // "results" — results present
    // "empty"   — search done, nothing found
    readonly property string state_: {
        if (searchBar.text.trim().length === 0)   return "idle"
        if (debounce.running)                     return "typing"
        if (resultsModel.count > 0)               return "results"
        if (isLoading)                            return "loading"
        return "empty"
    }

    property bool isLoading: false
    property string lastQuery: ""

    // ── Debounce timer ────────────────────────────────────────────────────────
    Timer {
        id: debounce
        interval: 500
        repeat: false
        onTriggered: {
            const q = searchBar.text.trim()
            if (q.length === 0) return
            root.lastQuery = q
            root.isLoading = true
            resultsModel.clear()
            simulatorIndex = 0
            resultSimulator.start()
        }
    }

    // ── Result simulation (replace with real backend call later) ─────────────
    property int simulatorIndex: 0
    readonly property var fakeResults: [
        { podcastName: "Crime Junkie",            author: "audiochuck",            artworkUrl: "" },
        { podcastName: "Serial",                  author: "This American Life",    artworkUrl: "" },
        { podcastName: "Stuff You Should Know",   author: "iHeart Podcasts",       artworkUrl: "" },
        { podcastName: "The Daily",               author: "The New York Times",    artworkUrl: "" },
        { podcastName: "Hardcore History",        author: "Dan Carlin",            artworkUrl: "" },
        { podcastName: "My Favorite Murder",      author: "Exactly Right Media",   artworkUrl: "" },
        { podcastName: "The Rest Is History",     author: "Goalhanger Podcasts",   artworkUrl: "" },
        { podcastName: "Armchair Expert",         author: "Dax Shepard",           artworkUrl: "" },
    ]

    Timer {
        id: resultSimulator
        interval: 120
        repeat: true
        onTriggered: {
            if (root.simulatorIndex >= root.fakeResults.length) {
                root.isLoading = false
                resultSimulator.stop()
                return
            }
            const r = root.fakeResults[root.simulatorIndex]
            resultsModel.append({
                podcastName: r.podcastName,
                author:      r.author,
                artworkUrl:  r.artworkUrl,
                subscribed:  false
            })
            root.simulatorIndex++
        }
    }

    ListModel { id: resultsModel }

    // ── Layout ────────────────────────────────────────────────────────────────
    // Search bar — sticky at the top
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
            root.isLoading = false
            resultSimulator.stop()
            debounce.restart()
        }

        Component.onCompleted: forceActiveFocus()
    }

    // Content area below the search bar
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
                text: "\ue8b6"   // search
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
                text: "\ue5c9"   // search_off
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

        // ── Results list ─────────────────────────────────────────────────
        ListView {
            id: resultsList
            anchors.fill: parent
            model: resultsModel
            clip: true
            visible: root.state_ === "results" || root.state_ === "loading" && resultsModel.count > 0

            // Animate rows sliding in from the bottom
            add: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.animFast }
                NumberAnimation { property: "y";       from: 8;        duration: Theme.animFast; easing.type: Easing.OutCubic }
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
