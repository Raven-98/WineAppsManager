import QtQuick
import QtQuick.Controls

import Modules
import Controls

Window {
    id: root
    visible: false
    modality: Qt.WindowModal

    default property alias content: content.children
    property alias customButtons: buttonsLeft.children
    property alias states: content.states
    property alias state: content.state
    property int standardButtons: DialogButtons.ok

    signal accepted()
    signal rejected()
    signal opened()

    function accept() {
        accepted()
        close()
    }
    function reject() {
        rejected()
        close()
    }

    onVisibleChanged: {
        if (visible) {
            minimumWidth = Math.max(content.implicitWidth, buttons.implicitWidth) + 20
            minimumHeight = content.implicitHeight + buttons.implicitHeight + 10
            opened()
        }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Colors.backgroundGradientStart }
            GradientStop { position: 1.0; color: Colors.backgroundGradientEnd }
        }
    }

    Item {
        id: content
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: buttons.top
        implicitHeight: children.length === 1 ? children[0].implicitHeight : (children.length ? childrenRect.height : 0)
        implicitWidth: children.length === 1 ? children[0].implicitWidth : (children.length ? childrenRect.width : 0)
    }

    Item {
        id: buttons
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        implicitHeight: Math.max(buttonsLeft.implicitHeight, buttonsRight.implicitHeight)
        implicitWidth: buttonsLeft.implicitWidth + 6 + buttonsRight.implicitWidth

        Flow {
            id: buttonsLeft
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            spacing: 6
            padding: 10
        }

        Flow {
            id: buttonsRight
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 6
            padding: 10

            Button {
                text: "Ok"
                visible: root.standardButtons === DialogButtons.ok ||
                            root.standardButtons === (DialogButtons.ok | DialogButtons.cancel)
                onClicked: root.accept()
            }
            Button {
                text: qsTr("Cancel")
                visible: root.standardButtons === DialogButtons.cancel ||
                            root.standardButtons === (DialogButtons.ok | DialogButtons.cancel)
                onClicked: root.reject()
            }
        }
    }
}
