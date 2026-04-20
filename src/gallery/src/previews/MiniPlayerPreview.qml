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
                text: "MiniPlayer"
                font.pixelSize: Theme.fontSizeH
                font.weight: Theme.fontWeightBold
                color: Theme.textPrimary
            }
            Text {
                text: "Persistent playback bar shown above the nav bar."
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

            // Playing — mid-progress, with artwork
            Column {
                width: parent.width
                leftPadding: Theme.spaceLg
                rightPadding: Theme.spaceLg
                spacing: Theme.spaceSm

                Text {
                    text: "PLAYING"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }
                MiniPlayer {
                    width: parent.width - Theme.spaceLg * 2
                    title: "S10 E05: The Turnpike Killer"
                    podcastName: "Crime Junkie"
                    artworkSource: Qt.resolvedUrl("../../assets/sample_artwork.svg")
                    position: 0.42
                    playing: true
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }

            // Paused
            Column {
                width: parent.width
                leftPadding: Theme.spaceLg
                rightPadding: Theme.spaceLg
                spacing: Theme.spaceSm

                Text {
                    text: "PAUSED"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }
                MiniPlayer {
                    width: parent.width - Theme.spaceLg * 2
                    title: "S10 E05: The Turnpike Killer"
                    podcastName: "Crime Junkie"
                    position: 0.42
                    playing: false
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }

            // Long title truncation
            Column {
                width: parent.width
                leftPadding: Theme.spaceLg
                rightPadding: Theme.spaceLg
                spacing: Theme.spaceSm

                Text {
                    text: "LONG TITLE"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }
                MiniPlayer {
                    width: parent.width - Theme.spaceLg * 2
                    title: "Deep Dive: The Complete History of the Byzantine Empire and Why It Still Matters Today"
                    podcastName: "Hardcore History — Dan Carlin's Mega-Epic Series"
                    position: 0.15
                    playing: true
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }

            // No artwork (placeholder)
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
                MiniPlayer {
                    width: parent.width - Theme.spaceLg * 2
                    title: "Episode 212"
                    podcastName: "Unknown Feed"
                    position: 0.75
                    playing: true
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }

            // Interactive — toggle play/pause
            Column {
                width: parent.width
                leftPadding: Theme.spaceLg
                rightPadding: Theme.spaceLg
                spacing: Theme.spaceSm

                Text {
                    text: "INTERACTIVE"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }

                MiniPlayer {
                    id: interactivePlayer
                    width: parent.width - Theme.spaceLg * 2
                    title: "The Happiness Lab with Dr. Laurie Santos"
                    podcastName: "Pushkin Industries"
                    artworkSource: Qt.resolvedUrl("../../assets/sample_artwork.svg")
                    position: 0.6
                    playing: false
                    onPlayPauseClicked: playing = !playing
                    onSkipForwardClicked: position = Math.min(1.0, position + 0.1)
                    onTapped: statusText.text = "Tapped — open full player"
                }

                Text {
                    id: statusText
                    text: "Tap the player body, play/pause, or skip forward"
                    font.pixelSize: Theme.fontSizeSm
                    color: Theme.textSecondary
                }
            }
        }
    }
}
