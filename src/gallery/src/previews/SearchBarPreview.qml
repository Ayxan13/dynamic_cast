import QtQuick
import QtQuick.Controls
import DynamicCast

ScrollView {
    id: root
    contentWidth: availableWidth

    Column {
        width: root.availableWidth
        spacing: 0

        // ── Title ─────────────────────────────────────────────────────────────
        Column {
            leftPadding: Theme.spaceLg
            topPadding: Theme.spaceLg
            bottomPadding: Theme.spaceMd
            spacing: Theme.spaceXs

            Text {
                text: "SearchBar"
                font.pixelSize: Theme.fontSizeH
                font.weight: Theme.fontWeightBold
                color: Theme.textPrimary
            }
            Text {
                text: "Search field with icon, placeholder, and clear button."
                font.pixelSize: Theme.fontSizeMd
                color: Theme.textSecondary
            }
        }

        Rectangle { width: parent.width; height: 1; color: Theme.divider }

        // ── Variants ──────────────────────────────────────────────────────────
        Column {
            width: parent.width
            topPadding: Theme.spaceLg
            bottomPadding: Theme.spaceLg
            spacing: Theme.spaceLg

            // Default
            Column {
                leftPadding: Theme.spaceLg
                spacing: Theme.spaceSm

                Text {
                    text: "DEFAULT"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }
                SearchBar {
                    width: 320
                    placeholder: "Search podcasts…"
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }

            // Disabled
            Column {
                leftPadding: Theme.spaceLg
                spacing: Theme.spaceSm

                Text {
                    text: "DISABLED"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }
                SearchBar {
                    width: 320
                    placeholder: "Search podcasts…"
                    enabled: false
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }

            // With text (shows clear button)
            Column {
                leftPadding: Theme.spaceLg
                spacing: Theme.spaceSm

                Text {
                    text: "WITH TEXT"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }
                SearchBar {
                    width: 320
                    text: "Serial"
                    placeholder: "Search podcasts…"
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }

            // Full width
            Column {
                leftPadding: Theme.spaceLg
                rightPadding: Theme.spaceLg
                width: parent.width
                spacing: Theme.spaceSm

                Text {
                    text: "FULL WIDTH"
                    font.pixelSize: Theme.fontSizeXs
                    font.weight: Theme.fontWeightBold
                    color: Theme.textSecondary
                    font.letterSpacing: 1.5
                }
                SearchBar {
                    width: parent.width - Theme.spaceLg * 2
                    placeholder: "Search podcasts…"
                }
            }

            Rectangle { width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }

            // Collapsible
            Column {
                width: parent.width
                spacing: Theme.spaceSm

                Column {
                    leftPadding: Theme.spaceLg
                    spacing: Theme.spaceXs

                    Text {
                        text: "COLLAPSIBLE"
                        font.pixelSize: Theme.fontSizeXs
                        font.weight: Theme.fontWeightBold
                        color: Theme.textSecondary
                        font.letterSpacing: 1.5
                    }
                    Text {
                        text: "Tap the icon to expand. Tap away or clear text to collapse."
                        font.pixelSize: Theme.fontSizeSm
                        color: Theme.textSecondary
                    }
                }

                // Simulate a page header so the expand-leftward behaviour is visible
                Rectangle {
                    width: parent.width
                    height: 56
                    color: Theme.bgSurface

                    Text {
                        anchors {
                            left: parent.left
                            leftMargin: Theme.spaceLg
                            verticalCenter: parent.verticalCenter
                        }
                        text: "My Page"
                        font.pixelSize: Theme.fontSizeLg
                        font.weight: Theme.fontWeightMedium
                        font.family: Theme.fontFamily
                        color: Theme.textPrimary
                        opacity: collapsibleBar.collapsed ? 1.0 : 0.0
                        Behavior on opacity { NumberAnimation { duration: Theme.animFast } }
                    }

                    SearchBar {
                        id: collapsibleBar
                        anchors {
                            right: parent.right
                            rightMargin: Theme.spaceMd
                            verticalCenter: parent.verticalCenter
                        }
                        collapsible: true
                        expandedWidth: parent.width - 2 * Theme.spaceMd
                        placeholder: "Search…"
                    }

                    // Dismiss overlay inside the preview header
                    MouseArea {
                        anchors.fill: parent
                        z: 1
                        enabled: !collapsibleBar.collapsed
                        onClicked: collapsibleBar.dismiss()
                    }
                }
            }
        }
    }
}
