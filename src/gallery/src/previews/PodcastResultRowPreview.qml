import QtQuick
import QtQuick.Controls
import DynamicCast

ScrollView {
    id: root
    contentWidth: availableWidth

    Column {
        width: root.availableWidth
        spacing: 0

        // ── Title ─────────────────────────────────────────────────────────────
        Column {
            leftPadding: Theme.spaceLg
            topPadding: Theme.spaceLg
            bottomPadding: Theme.spaceMd
            spacing: Theme.spaceXs

            Text {
                text: "PodcastResultRow"
                font.pixelSize: Theme.fontSizeH
                font.weight: Theme.fontWeightBold
                color: Theme.textPrimary
            }
            Text {
                text: "Search result row — artwork, name/author, subscribe toggle."
                font.pixelSize: Theme.fontSizeMd
                color: Theme.textSecondary
            }
        }

        Rectangle { width: parent.width; height: 1; color: Theme.divider }

        // ── Variants ──────────────────────────────────────────────────────────
        Column {
            width: parent.width
            topPadding: Theme.spaceLg
            bottomPadding: Theme.spaceLg
            spacing: Theme.spaceLg

            // Not subscribed
            Column {
                width: parent.width
                leftPadding: Theme.spaceLg
                rightPadding: Theme.spaceLg
                spacing: Theme.spaceSm

                Text {
                    text: "NOT SUBSCRIBED"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }
                Rectangle {
                    width: parent.width - Theme.spaceLg * 2
                    height: row1.implicitHeight
                    color: Theme.bgSurface
                    radius: Theme.radiusMd
                    clip: true

                    PodcastResultRow {
                        id: row1
                        width: parent.width
                        podcastName: "Crime Junkie"
                        author: "audiochuck"
                        artworkSource: Qt.resolvedUrl("../../assets/sample_artwork.svg")
                        onSubscribeClicked: subscribed = !subscribed
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }

            // Subscribed
            Column {
                width: parent.width
                leftPadding: Theme.spaceLg
                rightPadding: Theme.spaceLg
                spacing: Theme.spaceSm

                Text {
                    text: "SUBSCRIBED"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }
                Rectangle {
                    width: parent.width - Theme.spaceLg * 2
                    height: row2.implicitHeight
                    color: Theme.bgSurface
                    radius: Theme.radiusMd
                    clip: true

                    PodcastResultRow {
                        id: row2
                        width: parent.width
                        podcastName: "Hardcore History"
                        author: "Dan Carlin"
                        artworkSource: Qt.resolvedUrl("../../assets/sample_artwork.svg")
                        subscribed: true
                        onSubscribeClicked: subscribed = !subscribed
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }

            // No artwork
            Column {
                width: parent.width
                leftPadding: Theme.spaceLg
                rightPadding: Theme.spaceLg
                spacing: Theme.spaceSm

                Text {
                    text: "NO ARTWORK"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }
                Rectangle {
                    width: parent.width - Theme.spaceLg * 2
                    height: row3.implicitHeight
                    color: Theme.bgSurface
                    radius: Theme.radiusMd
                    clip: true

                    PodcastResultRow {
                        id: row3
                        width: parent.width
                        podcastName: "Unknown Feed"
                        author: "No Author"
                        onSubscribeClicked: subscribed = !subscribed
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }

            // Long names — truncation
            Column {
                width: parent.width
                leftPadding: Theme.spaceLg
                rightPadding: Theme.spaceLg
                spacing: Theme.spaceSm

                Text {
                    text: "LONG NAMES"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }
                Rectangle {
                    width: parent.width - Theme.spaceLg * 2
                    height: row4.implicitHeight
                    color: Theme.bgSurface
                    radius: Theme.radiusMd
                    clip: true

                    PodcastResultRow {
                        id: row4
                        width: parent.width
                        podcastName: "The Rest Is History: A Deep Dive Into Everything That Ever Happened"
                        author: "Tom Holland & Dominic Sandbrook — Goalhanger Podcasts"
                        onSubscribeClicked: subscribed = !subscribed
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }

            // Interactive list — simulated search results
            Column {
                width: parent.width
                leftPadding: Theme.spaceLg
                rightPadding: Theme.spaceLg
                spacing: Theme.spaceSm

                Text {
                    text: "INTERACTIVE LIST"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }

                Rectangle {
                    width: parent.width - Theme.spaceLg * 2
                    height: interactiveList.contentHeight
                    color: Theme.bgSurface
                    radius: Theme.radiusMd
                    clip: true

                    ListView {
                        id: interactiveList
                        anchors.fill: parent
                        interactive: false
                        model: ListModel {
                            ListElement { name: "Crime Junkie";             author: "audiochuck";          subscribed: false }
                            ListElement { name: "Serial";                   author: "This American Life";  subscribed: false }
                            ListElement { name: "Stuff You Should Know";    author: "iHeart Podcasts";     subscribed: true  }
                            ListElement { name: "The Daily";                author: "The New York Times";  subscribed: false }
                        }

                        delegate: Column {
                            width: interactiveList.width
                            spacing: 0

                            PodcastResultRow {
                                width: parent.width
                                podcastName: model.name
                                author: model.author
                                subscribed: model.subscribed
                                onSubscribeClicked: model.subscribed = !model.subscribed
                            }

                            Rectangle {
                                visible: index < interactiveList.count - 1
                                width: parent.width
                                height: 1
                                color: Theme.divider
                            }
                        }
                    }
                }
            }
        }
    }
}
