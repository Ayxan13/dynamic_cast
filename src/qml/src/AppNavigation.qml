pragma Singleton
import QtQuick
import QtQuick.Controls

QtObject {
    id: root

    property StackView stackView: null

    function push(url, props) {
        if (!stackView) return
        if (stackView.depth > 0 &&
            stackView.currentItem.toString().indexOf(url) >= 0) return
        stackView.push(Qt.resolvedUrl(url), props || {})
    }

    function pop() {
        if (stackView && stackView.depth > 1)
            stackView.pop()
    }
}
