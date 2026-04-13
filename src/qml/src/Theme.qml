pragma Singleton
import QtQuick


QtObject {
    // ── Color Palette ─────────────────────────────────────────────────────
    readonly property color bgBase:       "#0f0f1e"   // Deepest background
    readonly property color bgSurface:    "#1a1a2e"   // Cards, sheets
    readonly property color bgElevated:   "#252540"   // Dialogs, menus
    readonly property color bgRipple:     "#ffffff18" // Press states

    // Accent
    readonly property color accent:       "#4db6ac"
    readonly property color accentDark:   "#00897b"
    readonly property color accentLight:  "#80cbc4"

    // Text
    readonly property color textPrimary:   "#ffffff"
    readonly property color textSecondary: "#b0b0c8"
    readonly property color textDisabled:  "#606070"
    readonly property color textOnAccent:  "#ffffff"

    // Semantic
    readonly property color error:     "#ef5350"
    readonly property color warning:   "#ffa726"
    readonly property color divider:   "#ffffff1a"

    // Player progress bar track
    readonly property color progressTrack: "#ffffff30"
    readonly property color progressFill:  accent

    // Typography
    readonly property string fontFamily: Qt.platform.os === "android"
        ? "Roboto" : "system-ui"

    readonly property int fontSizeXs:   11
    readonly property int fontSizeSm:   13
    readonly property int fontSizeMd:   15
    readonly property int fontSizeLg:   18
    readonly property int fontSizeXl:   22
    readonly property int fontSizeH:    28

    readonly property int fontWeightNormal:   Font.Normal
    readonly property int fontWeightMedium:   Font.Medium
    readonly property int fontWeightBold:     Font.Bold

    // Spacing
    readonly property int spaceXs:  4
    readonly property int spaceSm:  8
    readonly property int spaceMd: 16
    readonly property int spaceLg: 24
    readonly property int spaceXl: 32

    // Radii
    readonly property int radiusSm:  6
    readonly property int radiusMd: 12
    readonly property int radiusLg: 20
    readonly property int radiusFull: 9999

    // Component Sizes
    readonly property int miniPlayerHeight:  72
    readonly property int bottomNavHeight:   60
    readonly property int artworkSizeSm:     48
    readonly property int artworkSizeMd:     80
    readonly property int artworkSizeLg:    160
    readonly property int artworkSizeXl:    240
    readonly property int iconSizeSm:        20
    readonly property int iconSizeMd:        24
    readonly property int iconSizeLg:        32
    readonly property int iconSizeXl:        48

    // Animation
    readonly property int animFast:   150
    readonly property int animNormal: 250
    readonly property int animSlow:   400
}
