import QtQuick
import QtQuick.Controls
import DynamicCast

Item {
    id: root

    readonly property var allSubscriptions: [
        { name: "Crime Junkie",          color: "#c0392b" },
        { name: "Serial",                color: "#2c3e50" },
        { name: "Stuff You Should Know", color: "#27ae60" },
        { name: "The Daily",             color: "#2980b9" },
        { name: "Hardcore History",      color: "#8e44ad" },
        { name: "My Favorite Murder",    color: "#d35400" },
        { name: "The Rest Is History",   color: "#16a085" },
        { name: "Armchair Expert",       color: "#f39c12" },
        { name: "Radiolab",              color: "#1abc9c" },
        { name: "Planet Money",          color: "#e74c3c" },
        { name: "Hidden Brain",          color: "#3498db" },
        { name: "Freakonomics",          color: "#7f8c8d" },
    ]

    readonly property string searchQuery: searchBar.text.trim().toLowerCase()
    readonly property var subscriptions: searchQuery.length === 0
        ? allSubscriptions
        : allSubscriptions.filter(s => s.name.toLowerCase().includes(searchQuery))

    // ── Grid (z=0, behind overlay) ────────────────────────────────────────────
    GridView {
        id: grid
        anchors {
            top: divider.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: Theme.spaceMd
            rightMargin: Theme.spaceMd
            bottomMargin: Theme.spaceMd
        }
        topMargin: Theme.spaceSm
        clip: true
        model: root.subscriptions

        readonly property real gap: Theme.spaceSm
        readonly property real cellSize: Math.floor(width / 4)
        cellWidth: cellSize
        cellHeight: cellSize

        delegate: Item {
            width: grid.cellWidth
            height: grid.cellHeight

            PodcastArtworkCard {
                anchors {
                    fill: parent
                    margins: Math.round(grid.gap / 2)
                }
                podcastName: modelData.name
                placeholderColor: modelData.color
            }
        }

        Text {
            anchors.centerIn: parent
            visible: grid.count === 0
            text: "No matches"
            font.pixelSize: Theme.fontSizeMd
            font.family: Theme.fontFamily
            color: Theme.textDisabled
        }

        ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
    }

    // ── Dismiss overlay (z=1) — tapping outside search bar collapses it ───────
    MouseArea {
        anchors.fill: parent
        z: 1
        enabled: !searchBar.collapsed
        onClicked: searchBar.dismiss()
    }

    // ── Header (z=2, always above grid and overlay) ───────────────────────────
    Item {
        id: header
        z: 2
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: 56

        Text {
            anchors {
                left: parent.left
                leftMargin: Theme.spaceMd
                verticalCenter: parent.verticalCenter
            }
            text: "Subscriptions"
            font.pixelSize: Theme.fontSizeLg
            font.weight: Theme.fontWeightMedium
            font.family: Theme.fontFamily
            color: Theme.textPrimary
            opacity: searchBar.collapsed ? 1.0 : 0.0
            Behavior on opacity { NumberAnimation { duration: Theme.animFast } }
        }

        SearchBar {
            id: searchBar
            anchors {
                right: parent.right
                rightMargin: Theme.spaceMd
                verticalCenter: parent.verticalCenter
            }
            collapsible: true
            expandedWidth: parent.width - 2 * Theme.spaceMd
            placeholder: "Search subscriptions…"
        }
    }

    Rectangle {
        id: divider
        z: 2
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
        }
        height: 1
        color: Theme.divider
    }
}
