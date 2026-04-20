import QtQuick
import QtQuick.Controls
import DynamicCast
import DynamicCastGallery

Item {
    Column {
        anchors.centerIn: parent
        spacing: Theme.spaceLg

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Placeholder (colour + initial)"
            font.pixelSize: Theme.fontSizeSm
            font.family: Theme.fontFamily
            color: Theme.textSecondary
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.spaceSm

            PodcastArtworkCard { width: 80; height: 80; podcastName: "Crime Junkie";    placeholderColor: "#c0392b" }
            PodcastArtworkCard { width: 80; height: 80; podcastName: "Serial";          placeholderColor: "#2c3e50" }
            PodcastArtworkCard { width: 80; height: 80; podcastName: "The Daily";       placeholderColor: "#2980b9" }
            PodcastArtworkCard { width: 80; height: 80; podcastName: "Hardcore History"; placeholderColor: "#8e44ad" }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Various sizes"
            font.pixelSize: Theme.fontSizeSm
            font.family: Theme.fontFamily
            color: Theme.textSecondary
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.spaceSm

            PodcastArtworkCard { width: 48;  height: 48;  podcastName: "Small";  placeholderColor: "#27ae60" }
            PodcastArtworkCard { width: 80;  height: 80;  podcastName: "Medium"; placeholderColor: "#d35400" }
            PodcastArtworkCard { width: 112; height: 112; podcastName: "Large";  placeholderColor: "#16a085" }
        }
    }
}
