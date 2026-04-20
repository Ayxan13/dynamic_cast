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
        }
    }
}
