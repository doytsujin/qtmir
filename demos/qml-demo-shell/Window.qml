import QtQuick 2.0
import Unity.Application 0.1

Rectangle {
    id: root
    color: "red"

    property var surface
    property bool touchMode: false

    width: surfaceItem.implicitWidth + 2*borderThickness
    height: surfaceItem.implicitHeight + 2*borderThickness + titleBar.height

    signal cloneRequested()
    property bool cloned: false

    onTouchModeChanged: {
        if (touchMode) {
            x -= borderThicknessTouch - borderThicknessMouse;
            width += 2*(borderThicknessTouch - borderThicknessMouse);
            y -= borderThicknessTouch - borderThicknessMouse;
            height += 2*(borderThicknessTouch - borderThicknessMouse);
        } else {
            x += borderThicknessTouch - borderThicknessMouse;
            width -= 2*(borderThicknessTouch - borderThicknessMouse);
            y += borderThicknessTouch - borderThicknessMouse;
            height -= 2*(borderThicknessTouch - borderThicknessMouse);
        }
    }

    readonly property real minWidth: 100
    readonly property real minHeight: 100

    property real borderThickness: touchMode ? borderThicknessTouch : borderThicknessMouse
    readonly property real borderThicknessMouse: 10
    readonly property real borderThicknessTouch: 40

    states: [
        State {
            name: "closed"
            when: (surface && !surface.live) || titleBar.closeRequested
        }
    ]
    transitions: [
        Transition {
            from: ""; to: "closed"
            SequentialAnimation {
                PropertyAnimation {
                    target: root
                    property: "scale"
                    easing.type: Easing.InBack
                    duration: 400
                    from: 1.0
                    to: 0.0
                }
                ScriptAction { script: { root.destroy(); } }
            }
        }
    ]


    MouseArea {
        anchors.fill: parent

        property real startX
        property real startY
        property real startWidth
        property real startHeight
        property bool leftBorder
        property bool rightBorder
        property bool topBorder
        property bool bottomBorder
        property bool dragging
        onPressedChanged: {
            if (pressed) {
                var pos = mapToItem(root.parent, mouseX, mouseY);
                startX = pos.x;
                startY = pos.y;
                startWidth = width;
                startHeight = height;
                leftBorder = mouseX > 0 && mouseX < root.borderThickness;
                rightBorder = mouseX > (root.width - root.borderThickness) && mouseX < root.width;
                topBorder = mouseY > 0 && mouseY < root.borderThickness;
                bottomBorder = mouseY > (root.height - root.borderThickness) && mouseY < root.height;
                dragging = true;
            } else {
                dragging = false;
            }
        }

        onMouseXChanged: {
            if (!pressed || !dragging) {
                return;
            }

            var pos = mapToItem(root.parent, mouseX, mouseY);

            if (leftBorder) {

                if (startX + startWidth - pos.x > root.minWidth) {
                    root.x = pos.x;
                    root.width = startX + startWidth - root.x;
                    startX = root.x;
                    startWidth = root.width;
                }

            } else if (rightBorder) {
                var deltaX = pos.x - startX;
                if (startWidth + deltaX >= root.minWidth) {
                    root.width = startWidth + deltaX;
                } else {
                    root.width = root.minWidth;
                }
            }
        }

        onMouseYChanged: {
            if (!pressed || !dragging) {
                return;
            }

            var pos = mapToItem(root.parent, mouseX, mouseY);

            if (topBorder) {

                if (startY + startHeight - pos.y > root.minHeight) {
                    root.y = pos.y;
                    root.height = startY + startHeight - root.y;
                    startY = root.y;
                    startHeight = root.height;
                }

            } else if (bottomBorder) {
                var deltaY = pos.y - startY;
                if (startHeight + deltaY >= root.minHeight) {
                    root.height = startHeight + deltaY;
                } else {
                    root.height = root.minHeight;
                }
            }
        }
    }

    TitleBar {
        id: titleBar
        anchors.left: parent.left
        anchors.leftMargin: root.borderThickness
        anchors.right: parent.right
        anchors.rightMargin: root.borderThickness
        anchors.top: parent.top
        anchors.topMargin: root.borderThickness

        target: root
        cloned: root.cloned
        onCloneRequested: { root.cloneRequested(); }
    }

    Item {
        id: surfaceItem

        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.leftMargin: root.borderThickness
        anchors.right: parent.right
        anchors.rightMargin: root.borderThickness
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.borderThickness

//        consumesInput: !root.cloned
//        surfaceWidth: root.cloned ? -1 : width
//        surfaceHeight: root.cloned ? -1 : height
    }
}
