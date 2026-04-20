import QtQuick
import DynamicCast

FocusScope {
    id: root

    property alias text: input.text
    property string placeholder: "Search"
    property bool collapsible: false
    property real expandedWidth: 300

    // Read-only: true when collapsible and currently showing as icon only
    readonly property bool collapsed: collapsible && !expanded

    // Writable so parents can collapse programmatically
    property bool expanded: false

    signal accepted(string text)

    // Collapse with optional text clear — call from outside to dismiss
    function dismiss() {
        input.text = ""
        expanded = false
    }

    implicitWidth: collapsed ? 44 : expandedWidth
    implicitHeight: 44

    opacity: enabled ? 1.0 : 0.4

    // Suppressed during initialization: when the parent assigns collapsible:true the
    // implicitWidth binding fires (300→44) before the first frame; without this guard
    // the Behavior would play a spurious collapse animation on every page load.
    property bool _behaviorEnabled: false
    Component.onCompleted: Qt.callLater(function() { root._behaviorEnabled = true })

    Behavior on implicitWidth {
        enabled: root._behaviorEnabled
        NumberAnimation { duration: Theme.animNormal; easing.type: Easing.OutCubic }
    }

    // Collapse when focus leaves and no text is present
    onActiveFocusChanged: {
        if (collapsible && !activeFocus && input.text.length === 0)
            expanded = false
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusFull
        color: Theme.bgElevated
        border.color: root.collapsed ? "transparent"
                    : root.activeFocus ? Theme.accent
                    : Theme.divider
        border.width: 1.5
        clip: true

        Behavior on border.color {
            ColorAnimation { duration: Theme.animFast }
        }

        // Search icon — centred when collapsed, left-aligned when expanded
        Text {
            id: searchIcon
            anchors {
                left: parent.left
                leftMargin: root.collapsed
                    ? Math.round((parent.width - width) / 2)
                    : Theme.spaceMd
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

        // Placeholder — hidden when collapsed
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
            visible: input.text.length === 0 && !root.activeFocus && !root.collapsed
        }

        // Text input — hidden when collapsed
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
            visible: !root.collapsed
            onAccepted: root.accepted(text)
        }

        // Clear button — hidden when collapsed
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
            visible: input.text.length > 0 && !root.collapsed

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

    // Tap anywhere in collapsed state to expand
    MouseArea {
        anchors.fill: parent
        enabled: root.collapsed
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.expanded = true
            input.forceActiveFocus()
        }
    }
}
