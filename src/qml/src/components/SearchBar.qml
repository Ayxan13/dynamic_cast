import QtQuick
import DynamicCast

FocusScope {
    id: root

    property alias text: input.text
    property string placeholder: "Search"

    signal accepted(string text)

    implicitWidth: 300
    implicitHeight: 44

    opacity: enabled ? 1.0 : 0.4

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusFull
        color: Theme.bgElevated
        border.color: root.activeFocus ? Theme.accent : Theme.divider
        border.width: 1.5

        Behavior on border.color {
            ColorAnimation { duration: Theme.animFast }
        }

        // Search icon
        Text {
            id: searchIcon
            anchors {
                left: parent.left
                leftMargin: Theme.spaceMd
                verticalCenter: parent.verticalCenter
            }
            text: "\ue8b6"
            font.family: "Material Icons"
            font.pixelSize: Theme.iconSizeMd
            color: root.activeFocus ? Theme.accent : Theme.textSecondary

            Behavior on color {
                ColorAnimation { duration: Theme.animFast }
            }
        }

        // Placeholder
        Text {
            anchors {
                left: searchIcon.right
                leftMargin: Theme.spaceSm
                right: clearBtn.visible ? clearBtn.left : parent.right
                rightMargin: Theme.spaceMd
                verticalCenter: parent.verticalCenter
            }
            text: root.placeholder
            font.pixelSize: Theme.fontSizeMd
            font.family: Theme.fontFamily
            color: Theme.textDisabled
            elide: Text.ElideRight
            visible: input.text.length === 0 && !root.activeFocus
        }

        // Text input
        TextInput {
            id: input
            anchors {
                left: searchIcon.right
                leftMargin: Theme.spaceSm
                right: clearBtn.visible ? clearBtn.left : parent.right
                rightMargin: Theme.spaceMd
                verticalCenter: parent.verticalCenter
            }
            color: Theme.textPrimary
            font.pixelSize: Theme.fontSizeMd
            font.family: Theme.fontFamily
            focus: true
            clip: true
            onAccepted: root.accepted(text)
        }

        // Clear button
        Text {
            id: clearBtn
            anchors {
                right: parent.right
                rightMargin: Theme.spaceMd
                verticalCenter: parent.verticalCenter
            }
            text: "\ue5cd"
            font.family: "Material Icons"
            font.pixelSize: Theme.iconSizeSm
            color: Theme.textSecondary
            visible: input.text.length > 0

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    input.text = ""
                    input.forceActiveFocus()
                }
            }
        }
    }
}
