import QtQuick
import QtQuick.Controls
import DynamicCast

Flickable {
    contentHeight: col.implicitHeight
    clip: true

    Column {
        id: col
        width: parent.width
        spacing: 0

        component Label: Item {
            property string text: ""
            width: parent.width
            height: 32
            Rectangle { anchors.fill: parent; color: Theme.bgBase }
            Text {
                anchors { left: parent.left; leftMargin: Theme.spaceMd; verticalCenter: parent.verticalCenter }
                text: parent.text
                font.pixelSize: Theme.fontSizeXs
                font.weight: Theme.fontWeightBold
                font.family: Theme.fontFamily
                font.letterSpacing: 1.2
                color: Theme.textDisabled
            }
        }

        // ── Full info · not started ───────────────────────────────────────────
        Label { text: "FULL INFO · NOT STARTED" }
        EpisodeListItem {
            width: parent.width
            episodeNumber: 312
            releaseDate: "Apr 18"
            episodeTitle: "The Surprisingly Interesting History of Sand"
            durationMinutes: 54
            progress: 0.0
        }

        // ── In progress ───────────────────────────────────────────────────────
        Label { text: "IN PROGRESS · 37%" }
        EpisodeListItem {
            width: parent.width
            episodeNumber: 311
            releaseDate: "Apr 11"
            episodeTitle: "Why Every City Has That One Weird Roundabout"
            durationMinutes: 38
            progress: 0.37
        }

        // ── Playing ───────────────────────────────────────────────────────────
        Label { text: "CURRENTLY PLAYING · 72%" }
        EpisodeListItem {
            width: parent.width
            episodeNumber: 310
            releaseDate: "Apr 4"
            episodeTitle: "The Invisible Rules of Elevator Etiquette"
            durationMinutes: 29
            progress: 0.72
            playing: true
        }

        // ── Fully played ──────────────────────────────────────────────────────
        Label { text: "FULLY PLAYED" }
        EpisodeListItem {
            width: parent.width
            episodeNumber: 309
            releaseDate: "Mar 28"
            episodeTitle: "How Fonts Secretly Shape Your Opinions"
            durationMinutes: 41
            progress: 1.0
        }

        // ── No episode number ─────────────────────────────────────────────────
        Label { text: "NO EPISODE NUMBER" }
        EpisodeListItem {
            width: parent.width
            episodeNumber: -1
            releaseDate: "Mar 21"
            episodeTitle: "Bonus: Live Q&A from Design Week"
            durationMinutes: 62
            progress: 0.0
        }

        // ── No date ───────────────────────────────────────────────────────────
        Label { text: "NO RELEASE DATE" }
        EpisodeListItem {
            width: parent.width
            episodeNumber: 308
            releaseDate: ""
            episodeTitle: "The Quiet Genius Behind Airport Wayfinding"
            durationMinutes: 33
            progress: 0.15
        }

        // ── No duration ───────────────────────────────────────────────────────
        Label { text: "NO DURATION" }
        EpisodeListItem {
            width: parent.width
            episodeNumber: 307
            releaseDate: "Mar 7"
            episodeTitle: "An Episode With No Known Length"
            durationMinutes: -1
            progress: 0.0
        }

        // ── Archived ──────────────────────────────────────────────────────────
        Label { text: "ARCHIVED (DIMMED)" }
        EpisodeListItem {
            width: parent.width
            episodeNumber: 300
            releaseDate: "Jan 3"
            episodeTitle: "This Episode Is Archived"
            durationMinutes: 45
            progress: 1.0
            archived: true
        }

        // ── Long title (wraps) ────────────────────────────────────────────────
        Label { text: "LONG TITLE WRAPPING TO TWO LINES" }
        EpisodeListItem {
            width: parent.width
            episodeNumber: 299
            releaseDate: "Dec 20"
            episodeTitle: "An Extraordinarily Long Episode Title That Demonstrates How Two-Line Wrapping Behaves in This Component"
            durationMinutes: 51
            progress: 0.0
        }

        Item { width: 1; height: Theme.spaceLg }
    }
}
