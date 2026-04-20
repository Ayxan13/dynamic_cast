import QtQuick
import QtQuick.Controls
import DynamicCast

Item {
    id: root

    readonly property var components: [
        { name: "SearchBar",        source: Qt.resolvedUrl("previews/SearchBarPreview.qml")        },
        { name: "BottomNavBar",     source: Qt.resolvedUrl("previews/BottomNavBarPreview.qml")     },
        { name: "MiniPlayer",       source: Qt.resolvedUrl("previews/MiniPlayerPreview.qml")       },
        { name: "PodcastResultRow", source: Qt.resolvedUrl("previews/PodcastResultRowPreview.qml") },
        { name: "SearchPage",       source: Qt.resolvedUrl("previews/SearchPagePreview.qml")       }
    ]

    property int selectedIndex: {
        if (typeof _initialComponent === "undefined" || _initialComponent === "") return 0
        const idx = components.findIndex(c => c.name === _initialComponent)
        return idx >= 0 ? idx : 0
    }

    // ── Sidebar ───────────────────────────────────────────────────────────────
    Rectangle {
        id: sidebar
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        width: 200
        color: Theme.bgSurface

        // Header
        Item {
            id: sidebarHeader
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: 52

            Text {
                anchors {
                    left: parent.left
                    leftMargin: Theme.spaceMd
                    verticalCenter: parent.verticalCenter
                }
                text: "COMPONENTS"
                font.pixelSize: Theme.fontSizeXs
                font.weight: Theme.fontWeightBold
                color: Theme.textSecondary
                font.letterSpacing: 1.5
            }
        }

        Rectangle {
            anchors.top: sidebarHeader.bottom
            width: parent.width
            height: 1
            color: Theme.divider
        }

        // Component list
        ListView {
            anchors {
                top: sidebarHeader.bottom
                topMargin: 1
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }
            model: root.components
            clip: true

            delegate: Item {
                width: ListView.view.width
                height: 44

                Rectangle {
                    anchors.fill: parent
                    color: index === root.selectedIndex ? Theme.bgElevated : "transparent"
                }

                // Selection accent bar
                Rectangle {
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                    }
                    width: 3
                    color: index === root.selectedIndex ? Theme.accent : "transparent"
                }

                Text {
                    anchors {
                        left: parent.left
                        leftMargin: Theme.spaceLg
                        verticalCenter: parent.verticalCenter
                    }
                    text: modelData.name
                    font.pixelSize: Theme.fontSizeMd
                    color: index === root.selectedIndex
                        ? Theme.textPrimary : Theme.textSecondary
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.selectedIndex = index
                }
            }
        }
    }

    // Sidebar / content divider
    Rectangle {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: sidebar.right
        }
        width: 1
        color: Theme.divider
    }

    // ── Preview area ──────────────────────────────────────────────────────────
    Item {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: sidebar.right
            leftMargin: 1
            right: parent.right
        }

        Loader {
            anchors.fill: parent
            source: root.components[root.selectedIndex].source
        }
    }
}
