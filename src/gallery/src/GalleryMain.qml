import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import DynamicCast

ApplicationWindow {
    visible: true
    width: 960
    height: 640
    title: "DynamicCast — Component Gallery"

    Material.theme: Material.Dark
    Material.accent: Theme.accent
    Material.background: Theme.bgBase

    color: Theme.bgBase

    Gallery {
        anchors.fill: parent
    }
}
