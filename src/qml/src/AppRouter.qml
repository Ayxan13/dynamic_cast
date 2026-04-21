import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import DynamicCast

Item {
    id: root

    property int currentIndex: 0

    readonly property var navItems: [
        { icon: "", label: "Home",          page: "pages/HomePage.qml"          },
        { icon: "", label: "Subscriptions", page: "pages/SubscriptionsPage.qml" },
        { icon: "", label: "Search",        page: "pages/SearchPage.qml"        },
        { icon: "", label: "Downloads",     page: "pages/DownloadsPage.qml"     }
    ]

    StackView {
        id: stack
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: /*miniPlayer.visible ? miniPlayer.top : */navBar.top
        }

        initialItem: "pages/HomePage.qml"

        pushEnter: Transition {
            PropertyAction  { property: "z"; value: 1 }
            NumberAnimation { property: "x"; from: stack.width; to: 0; duration: Theme.animNormal; easing.type: Easing.OutCubic }
        }
        pushExit: Transition {
            PropertyAction  { property: "z"; value: 0 }
            NumberAnimation { property: "x"; from: 0; to: -stack.width / 3; duration: Theme.animNormal; easing.type: Easing.OutCubic }
            NumberAnimation { property: "opacity"; from: 1; to: 0.5; duration: Theme.animNormal }
        }
        popEnter: Transition {
            PropertyAction  { property: "z"; value: 0 }
            NumberAnimation { property: "x"; from: -stack.width / 3; to: 0; duration: Theme.animNormal; easing.type: Easing.OutCubic }
            NumberAnimation { property: "opacity"; from: 0.5; to: 1; duration: Theme.animNormal }
        }
        popExit: Transition {
            PropertyAction  { property: "z"; value: 1 }
            NumberAnimation { property: "x"; from: 0; to: stack.width; duration: Theme.animNormal; easing.type: Easing.OutCubic }
        }

        Component.onCompleted: {
            AppNavigation.stackView = stack
        }

        function replaceRoot(pageUrl) {
            stack.replace(null, Qt.resolvedUrl(pageUrl))
        }
    }

    BottomNavBar {
        id: navBar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        navItems: root.navItems
        currentIndex: root.currentIndex
        onItemSelected: (index) => {
            root.currentIndex = index
            stack.replaceRoot(navItems[index].page)
        }
    }
}
