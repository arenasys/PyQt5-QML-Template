import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.15

import gui 1.0

import "style"
import "components"

FocusReleaser {
    property var window
    anchors.fill: parent  
    
    Component.onCompleted: {
        window.title = Qt.binding(function() { return GUI.title; })
    }

    Rectangle {
        id: root
        anchors.fill: parent
        color: COMMON.bg0
    }

    WindowBar {
        id: windowBar
        anchors.left: root.left
        anchors.right: root.right
    }

    Item {
        id: main
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: windowBar.bottom
        anchors.bottom: parent.bottom

        Item {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 20

            width: Math.max(200, parent.width - 40)
            height: Math.max(200, parent.height - 40)

            Rectangle {
                id: imageBox
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: textBox.top
                anchors.bottomMargin: 5

                border.width: 1
                border.color: COMMON.bg4
                color: COMMON.bg0
                clip: true

                Rectangle {
                    id: imageBoxHeader
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 25
                    border.width: 1
                    border.color: COMMON.bg4
                    color: COMMON.bg3
                    
                    SText {
                        anchors.fill: parent
                        text: "Image area"
                        color: COMMON.fg1_5
                        leftPadding: 5
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MovableItem {
                    id: imageBoxArea
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: imageBoxHeader.bottom
                    anchors.bottom: parent.bottom
                    anchors.margins: 2
                    anchors.topMargin: 1
                    
                    itemWidth: 200
                    itemHeight: 200

                    SGlow {
                        target: imageBoxArea.item
                    }

                    Rectangle {
                        anchors.fill: imageBoxArea.item
                        color: COMMON.bg0
                        border.width: 1
                        border.color: COMMON.bg4

                        Image {
                            source: "qrc:/icons/placeholder.svg"
                            height: parent.width/2
                            width: height
                            sourceSize: Qt.size(width*1.25, height*1.25)
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            Rectangle {
                id: textBox
                anchors.left: parent.left
                anchors.right: updateBox.left
                anchors.bottom: parent.bottom
                height: 150
                anchors.rightMargin: 5

                border.width: 1
                border.color: COMMON.bg4
                color: COMMON.bg0
                clip: true

                Rectangle {
                    id: textBoxHeader
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 25
                    border.width: 1
                    border.color: COMMON.bg4
                    color: COMMON.bg3
                    
                    SText {
                        anchors.fill: parent
                        text: "Text area"
                        color: COMMON.fg1_5
                        leftPadding: 5
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                STextArea {
                    id: textBoxArea
                    color: COMMON.bg1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: textBoxHeader.bottom
                    anchors.bottom: parent.bottom
                    anchors.margins: 1
                    text: "Blah Blah"
                }
            }

            Rectangle {
                id: updateBox
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                height: 150
                width: 300

                border.width: 1
                border.color: COMMON.bg4
                color: COMMON.bg0
                clip: true

                Rectangle {
                    id: updateBoxHeader
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 25
                    border.width: 1
                    border.color: COMMON.bg4
                    color: COMMON.bg3
                    
                    SText {
                        anchors.fill: parent
                        text: "Update area"
                        color: COMMON.fg1_5
                        leftPadding: 5
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Rectangle {
                    id: updateBoxArea
                    color: COMMON.bg1
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: updateBoxHeader.bottom
                    anchors.bottom: parent.bottom
                    anchors.margins: 1

                    SText {
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: updateButton.top
                        text: GUI.versionInfo
                        color: COMMON.fg1_5
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    SButton {
                        id: updateButton
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        height: 30
                        label: disabled ? "" : "Update"
                        disabled: GUI.updating || GUI.needRestart

                        onPressed: {
                            GUI.update()
                        }

                        SText {
                            anchors.fill: parent
                            visible: GUI.needRestart
                            text: "Restart required"
                            color: COMMON.accent(0)
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            pointSize: 9.0
                        }

                        LoadingSpinner {
                            anchors.centerIn: parent
                            height: 20
                            width: height
                            size: 20
                            running: GUI.updating
                            source: "qrc:/icons/loading_big.svg"
                        }
                    }
                }
            }
        }

    }

    onReleaseFocus: {
        keyboardFocus.forceActiveFocus()
    }

    Item {
        id: keyboardFocus
        Keys.onPressed: {
            event.accepted = false
        }
        Keys.forwardTo: [main]
    }
}