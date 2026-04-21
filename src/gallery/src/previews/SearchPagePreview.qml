import QtQuick
import QtQuick.Controls
import DynamicCast

// Side-by-side snapshot of every SearchPage state
Item {
    id: root

    component StateFrame: Item {
        property string label: ""
        default property alias frameContent: frameBody.data

        width: 160
        height: column.implicitHeight

        Column {
            id: column
            width: parent.width
            spacing: Theme.spaceXs

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: parent.parent.label
                font.pixelSize: Theme.fontSizeXs
                font.family: Theme.fontFamily
                font.weight: Theme.fontWeightMedium
                color: Theme.textSecondary
                font.letterSpacing: 1.2
            }

            Rectangle {
                width: parent.width
                height: 420
                color: Theme.bgBase
                radius: Theme.radiusMd
                clip: true

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.color: Theme.divider
                    border.width: 1
                    radius: parent.radius
                    z: 1
                }

                // search bar mock at top
                Rectangle {
                    id: mockBar
                    anchors {
                        top: parent.top
                        topMargin: Theme.spaceMd
                        left: parent.left
                        leftMargin: Theme.spaceMd
                        right: parent.right
                        rightMargin: Theme.spaceMd
                    }
                    height: 36
                    radius: Theme.radiusFull
                    color: Theme.bgSurface

                    Text {
                        anchors {
                            left: parent.left
                            leftMargin: Theme.spaceSm
                            verticalCenter: parent.verticalCenter
                        }
                        text: ""
                        font.family: "Material Icons"
                        font.pixelSize: Theme.iconSizeSm
                        color: Theme.textDisabled
                    }
                }

                Item {
                    id: frameBody
                    anchors {
                        top: mockBar.bottom
                        topMargin: Theme.spaceMd
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }
                }
            }
        }
    }

    Row {
        anchors.centerIn: parent
        spacing: Theme.spaceMd

        // ── Idle ─────────────────────────────────────────────────────────────
        StateFrame {
            label: "IDLE"
            Column {
                anchors.centerIn: parent
                width: parent.width - Theme.spaceLg * 2
                spacing: Theme.spaceSm
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: ""
                    font.family: "Material Icons"
                    font.pixelSize: Theme.iconSizeXl
                    color: Theme.textDisabled
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    text: "Discover podcasts"
                    font.pixelSize: Theme.fontSizeLg
                    font.family: Theme.fontFamily
                    font.weight: Theme.fontWeightMedium
                    color: Theme.textSecondary
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    text: "Search by title, host, or topic"
                    font.pixelSize: Theme.fontSizeSm
                    font.family: Theme.fontFamily
                    color: Theme.textDisabled
                }
            }
        }

        // ── Loading ───────────────────────────────────────────────────────────
        StateFrame {
            label: "LOADING"
            Column {
                anchors.centerIn: parent
                width: parent.width - Theme.spaceLg * 2
                spacing: Theme.spaceMd
                BusyIndicator {
                    anchors.horizontalCenter: parent.horizontalCenter
                    running: true
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "Searching…"
                    font.pixelSize: Theme.fontSizeSm
                    font.family: Theme.fontFamily
                    color: Theme.textDisabled
                }
            }
        }

        // ── Empty ─────────────────────────────────────────────────────────────
        StateFrame {
            label: "EMPTY"
            Column {
                anchors.centerIn: parent
                width: parent.width - Theme.spaceLg * 2
                spacing: Theme.spaceSm
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: ""
                    font.family: "Material Icons"
                    font.pixelSize: Theme.iconSizeXl
                    color: Theme.textDisabled
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    text: "No results for “true crime”"
                    font.pixelSize: Theme.fontSizeMd
                    font.family: Theme.fontFamily
                    color: Theme.textSecondary
                }
            }
        }

        // ── Error ─────────────────────────────────────────────────────────────
        StateFrame {
            label: "ERROR"
            Column {
                anchors.centerIn: parent
                width: parent.width - Theme.spaceLg * 2
                spacing: Theme.spaceSm
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: ""
                    font.family: "Material Icons"
                    font.pixelSize: Theme.iconSizeXl
                    color: Theme.error
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    text: "Search failed"
                    font.pixelSize: Theme.fontSizeMd
                    font.family: Theme.fontFamily
                    font.weight: Theme.fontWeightMedium
                    color: Theme.textSecondary
                }
                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.Wrap
                    text: "Network request timed out"
                    font.pixelSize: Theme.fontSizeXs
                    font.family: Theme.fontFamily
                    color: Theme.textDisabled
                }
            }
        }
    }
}
