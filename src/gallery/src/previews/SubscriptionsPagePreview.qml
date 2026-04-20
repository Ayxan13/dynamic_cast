import QtQuick
import DynamicCast

// Simulate the app shell: phone frame centred in the preview area.
// Cap height so the frame never overflows the gallery window.
Item {
    Rectangle {
        anchors.centerIn: parent
        width: 400
        height: Math.min(700, parent.height - 40)
        color: Theme.bgBase
        clip: true

        SubscriptionsPage { anchors.fill: parent }
    }
}
