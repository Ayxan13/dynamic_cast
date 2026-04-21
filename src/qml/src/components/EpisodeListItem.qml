import QtQuick
import DynamicCast

Item {
    id: root

    property int    episodeNumber:   -1    // -1 = unknown
    property string releaseDate:     ""    // "" = unknown
    property string episodeTitle:    ""
    property int    durationMinutes: -1    // -1 = unknown
    property real   progress:        0.0   // 0.0 – 1.0
    property bool   playing:         false
    property bool   archived:        false

    signal playPauseClicked()

    implicitWidth:  400
    implicitHeight: Math.max(72, contentArea.implicitHeight + Theme.spaceMd * 2)

    opacity: root.archived ? 0.55 : 1.0
    Behavior on opacity { NumberAnimation { duration: Theme.animNormal } }

    // ── Derived display strings ───────────────────────────────────────────────
    readonly property string _metaText: {
        var parts = []
        if (root.episodeNumber >= 0) parts.push("E" + root.episodeNumber)
        if (root.releaseDate !== "") parts.push(root.releaseDate)
        return parts.join(" · ")
    }

    readonly property string _durationText: {
        if (root.durationMinutes <= 0) return ""
        if (root.progress >= 1.0) return "Played"
        if (root.progress > 0.0) {
            var left = Math.max(1, Math.round(root.durationMinutes * (1.0 - root.progress)))
            return left + "m left"
        }
        return root.durationMinutes + "m"
    }

    // ── Content ───────────────────────────────────────────────────────────────
    Item {
        id: contentArea
        anchors {
            left: parent.left;   leftMargin:  Theme.spaceMd
            right: parent.right; rightMargin: Theme.spaceSm
            verticalCenter: parent.verticalCenter
        }
        implicitHeight: Math.max(playBtn.height, episodeCol.implicitHeight)
        height: implicitHeight

        // Play/pause button with circular progress ring
        Item {
            id: playBtn
            width: 44
            height: 44
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }

            Canvas {
                id: progressArc
                anchors.fill: parent

                Component.onCompleted: requestPaint()

                Connections {
                    target: root
                    function onProgressChanged() { progressArc.requestPaint() }
                    function onPlayingChanged()   { progressArc.requestPaint() }
                }

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var cx = width  / 2
                    var cy = height / 2
                    var r  = 17
                    var lw = 2.5

                    // Track ring
                    ctx.beginPath()
                    ctx.arc(cx, cy, r, 0, Math.PI * 2)
                    ctx.strokeStyle = Theme.bgElevated
                    ctx.lineWidth   = lw
                    ctx.stroke()

                    // Progress arc (clockwise from 12 o'clock)
                    var p = Math.max(0.0, Math.min(1.0, root.progress))
                    if (p > 0.0) {
                        ctx.beginPath()
                        ctx.arc(cx, cy, r,
                                -Math.PI / 2,
                                -Math.PI / 2 + Math.PI * 2 * p)
                        ctx.strokeStyle = Theme.accent
                        ctx.lineWidth   = lw
                        ctx.lineCap     = "round"
                        ctx.stroke()
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                text: root.playing ? "" : ""   // pause / play_arrow
                font.family:    "Material Icons"
                font.pixelSize: Theme.iconSizeSm
                color: root.playing ? Theme.accent : Theme.textPrimary

                Behavior on color { ColorAnimation { duration: Theme.animFast } }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.playPauseClicked()
            }
        }

        // Episode info column
        Column {
            id: episodeCol
            anchors {
                left: parent.left
                right: playBtn.left; rightMargin: Theme.spaceMd
                verticalCenter: parent.verticalCenter
            }
            spacing: 3

            // Episode number + release date
            Text {
                width: parent.width
                visible: root._metaText !== ""
                text: root._metaText
                font.pixelSize: Theme.fontSizeXs
                font.family:    Theme.fontFamily
                color: Theme.textSecondary
                elide: Text.ElideRight
            }

            // Episode title
            Text {
                width: parent.width
                text: root.episodeTitle
                font.pixelSize: Theme.fontSizeSm
                font.weight:    Theme.fontWeightMedium
                font.family:    Theme.fontFamily
                color: Theme.textPrimary
                elide: Text.ElideRight
                maximumLineCount: 2
                wrapMode: Text.WordWrap
            }

            // Duration / time left / played
            Text {
                width: parent.width
                visible: root._durationText !== ""
                text: root._durationText
                font.pixelSize: Theme.fontSizeXs
                font.family:    Theme.fontFamily
                color: (root.progress > 0.0 && root.progress < 1.0)
                       ? Theme.accent : Theme.textSecondary
                elide: Text.ElideRight
            }
        }
    }

    // Bottom divider
    Rectangle {
        anchors {
            bottom: parent.bottom
            left: parent.left;  leftMargin: Theme.spaceMd
            right: parent.right
        }
        height: 1
        color: Theme.divider
    }
}
