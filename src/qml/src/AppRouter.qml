import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import DynamicCast

Item {
    id: root

    property int currentIndex: 0

    readonly property var navItems: [
        { icon: "\ue88a", label: "Home",          page: "pages/HomePage.qml"          },
        { icon: "\ue5c3", label: "Subscriptions", page: "pages/SubscriptionsPage.qml" },
        { icon: "\ue8b6", label: "Search",        page: "pages/SearchPage.qml"        },
        { icon: "\ue2c4", label: "Downloads",     page: "pages/DownloadsPage.qml"     }
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
            XAnimator { from: stack.width; to: 0; duration: Theme.animNormal; easing.type: Easing.OutCubic }
        }
        pushExit: Transition {
            XAnimator { from: 0; to: -stack.width / 3; duration: Theme.animNormal; easing.type: Easing.OutCubic }
            OpacityAnimator { from: 1; to: 0.5; duration: Theme.animNormal }
        }
        popEnter: Transition {
            XAnimator { from: -stack.width / 3; to: 0; duration: Theme.animNormal; easing.type: Easing.OutCubic }
            OpacityAnimator { from: 0.5; to: 1; duration: Theme.animNormal }
        }
        popExit: Transition {
            XAnimator { from: 0; to: stack.width; duration: Theme.animNormal; easing.type: Easing.OutCubic }
        }

        function navigateTo(pageUrl, props) {
            if (stack.depth > 0 &&
                stack.currentItem.toString().indexOf(pageUrl) >= 0) return
            stack.push(Qt.resolvedUrl(pageUrl), props || {})
        }

        function replaceRoot(pageUrl) {
            stack.replace(null, Qt.resolvedUrl(pageUrl))
        }
    }

    Rectangle {
        id: navBar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: Theme.bottomNavHeight + safeAreaBottom
        color: Theme.bgSurface

        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            color: Theme.divider
        }

        property real safeAreaBottom: Qt.platform.os === "ios" ? 34 : 0

        Row {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: Theme.bottomNavHeight

            Repeater {
                model: root.navItems
                delegate: Item {
                    width: navBar.width / root.navItems.length
                    height: Theme.bottomNavHeight

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"

                        Column {
                            anchors.centerIn: parent
                            spacing: 2

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.icon
                                font.family: "Material Icons"
                                font.pixelSize: Theme.iconSizeMd
                                color: index === root.currentIndex
                                    ? Theme.accent : Theme.textSecondary
                            }
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.label
                                font.pixelSize: Theme.fontSizeXs
                                color: index === root.currentIndex
                                    ? Theme.accent : Theme.textSecondary
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                root.currentIndex = index
                                stack.replaceRoot(modelData.page)
                            }
                        }
                    }
                }
            }
        }
    }
}
