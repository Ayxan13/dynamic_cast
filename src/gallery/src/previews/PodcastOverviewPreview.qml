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

        // ── Section label helper ──────────────────────────────────────────────
        component Label: Item {
            property string text: ""
            width: parent.width
            height: 36
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

        // ── 1. Full info · not following ──────────────────────────────────────
        Label { text: "FULL INFO · NOT FOLLOWING" }
        PodcastOverview {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(parent.width, 420)
            podcastName: "Hardcore History"
            author: "Dan Carlin"
            genre: "History"
            rating: 4.9
            ratingCount: 128400
            following: false
            description: "In 'Hardcore History' journalist and broadcaster Dan Carlin takes his " +
                         "unique approach to the past and presents it as a dramatic, epic, and " +
                         "emotionally-connected story. If you like the great Bill Bryson quote " +
                         "about history, this show is for you."
            websiteUrl: "dancarlin.com/hardcore-history"
        }

        Rectangle { width: parent.width; height: 1; color: Theme.divider }

        // ── 2. Following · notifications off ─────────────────────────────────
        Label { text: "FOLLOWING · NOTIFICATIONS OFF" }
        PodcastOverview {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(parent.width, 420)
            podcastName: "Serial"
            author: "This American Life"
            genre: "True Crime"
            rating: 4.7
            ratingCount: 87200
            following: true
            notificationsEnabled: false
            description: "Serial is a podcast from the creators of This American Life, hosted by " +
                         "Sarah Koenig. Serial unfolds one story — a true story — over the course " +
                         "of a whole season."
        }

        Rectangle { width: parent.width; height: 1; color: Theme.divider }

        // ── 3. Following · notifications on ──────────────────────────────────
        Label { text: "FOLLOWING · NOTIFICATIONS ON" }
        PodcastOverview {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(parent.width, 420)
            podcastName: "The Daily"
            author: "The New York Times"
            genre: "News"
            rating: 4.6
            ratingCount: 312000
            following: true
            notificationsEnabled: true
            description: "This is what the news should sound like. The biggest stories of our " +
                         "time, told by the best journalists in the world."
        }

        Rectangle { width: parent.width; height: 1; color: Theme.divider }

        // ── 4. Minimal — no optional fields ──────────────────────────────────
        Label { text: "MINIMAL — NO AUTHOR, GENRE, RATING, DESCRIPTION" }
        PodcastOverview {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(parent.width, 420)
            podcastName: "Mystery Show"
        }

        Rectangle { width: parent.width; height: 1; color: Theme.divider }

        // ── 5. Genre only · description · no rating ───────────────────────────
        Label { text: "GENRE ONLY · HAS DESCRIPTION · NO RATING" }
        PodcastOverview {
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(parent.width, 420)
            podcastName: "99% Invisible"
            genre: "Design"
            description: "99% Invisible is about all the thought that goes into the things we " +
                         "don't think about — the unnoticed architecture and design that shape " +
                         "our world."
            websiteUrl: "99percentinvisible.org"
        }

        Item { width: 1; height: Theme.spaceLg }
    }
}
