import QtQuick
import QtQuick.Controls.Material
import DynamicCast

Rectangle {
    id: root

    property int currentIndex: 0
    property var navItems: []

    signal itemSelected(int index)

    property real safeAreaBottom: Qt.platform.os === "ios" ? 34 : 0

    height: Theme.bottomNavHeight + safeAreaBottom
    color: Theme.bgSurface

    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 1
        color: Theme.divider
    }

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
                width: root.width / root.navItems.length
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
                        onClicked: root.itemSelected(index)
                    }
                }
            }
        }
    }
}
