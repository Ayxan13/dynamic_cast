import QtQuick
import DynamicCast

Item {
    readonly property var sampleItems: [
        { icon: "\ue88a", label: "Home"          },
        { icon: "\ue5c3", label: "Subscriptions" },
        { icon: "\ue8b6", label: "Search"        },
        { icon: "\ue2c4", label: "Downloads"     }
    ]

    // ── Default (first tab selected) ─────────────────────────────────────────
    Column {
        anchors.centerIn: parent
        spacing: Theme.spaceLg

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "First tab active"
            font.pixelSize: Theme.fontSizeSm
            color: Theme.textSecondary
        }

        BottomNavBar {
            width: 400
            navItems: sampleItems
            currentIndex: 0
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Third tab active"
            font.pixelSize: Theme.fontSizeSm
            color: Theme.textSecondary
        }

        BottomNavBar {
            width: 400
            navItems: sampleItems
            currentIndex: 2
        }

        // Interactive variant
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Interactive"
            font.pixelSize: Theme.fontSizeSm
            color: Theme.textSecondary
        }

        BottomNavBar {
            id: interactive
            width: 400
            navItems: sampleItems
            currentIndex: 0
            onItemSelected: (index) => currentIndex = index
        }
    }
}
