import QtQuick
import QtQuick.Controls
import QtCore
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

ShellRoot {
    id: root

    IpcHandler {
        id: noteHandler
        target: "note"

        function toggle() {
            root.shown = !root.shown
            if (root.shown) {
                noteText.forceActiveFocus()
            } else {
                noteText.focus = false
            }
        }
    }

    property bool shown: false
    property bool noteLoaded: false

    readonly property string notePath:
    StandardPaths.writableLocation(StandardPaths.HomeLocation)
    + "/.local/share/quickshell-stickynote.txt"

    FileView {
        id: noteFile
        path: root.notePath

        onLoaded: {
            noteText.text = noteFile.text()
            root.noteLoaded = true
        }

        onLoadFailed: root.noteLoaded = true

        onSaved: console.log("Note saved successfully")
        onSaveFailed: console.error("Failed to save note:", error)
    }

    function saveNote() {
        if (root.noteLoaded) {
            noteFile.setText(noteText.text)
        }
    }

    PanelWindow {
        id: window

        implicitWidth: 460
        implicitHeight: 580
        color: "transparent"

        anchors {
            top: true
            right: true
        }

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: root.shown ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

        mask: root.shown ? null : region

        Region {
            id: region
        }

        exclusionMode: ExclusionMode.Ignore



        Item {
            id: slideWrapper
            width: 420
            height: 540

            anchors {
                top: parent.top
                right: parent.right
                topMargin: 20
                rightMargin: 20
            }

            transform: Translate {
                x: root.shown ? 0 : 480
                y: root.shown ? 0 : -100

                Behavior on x {
                    NumberAnimation { duration: 380; easing.type: Easing.OutCubic }
                }
                Behavior on y {
                    NumberAnimation { duration: 380; easing.type: Easing.OutCubic }
                }
            }

            Rectangle {
                id: noteBody
                anchors.fill: parent
                radius: 16
                color: "#fff9c4"
                border.width: 4
                border.color: "#f9a825"
                clip: true

                Rectangle {
                    id: dragHandle
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 60
                    color: "#ffe082"
                    radius: 16

                    Text {
                        anchors.centerIn: parent
                        text: "✦  Sticky Note  — drag here  ✦"
                        font.pixelSize: 15
                        font.bold: true
                        color: "#827717"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor

                        property int startX: 0
                        property int startY: 0

                        onPressed: (mouse) => {
                            startX = mouse.x
                            startY = mouse.y
                        }

                        onPositionChanged: (mouse) => {
                            if (pressed) {
                                // Faster but still smooth (0.75)
                                var dx = (mouse.x - startX) * 3.5
                                var dy = (mouse.y - startY) * 3.5

                                window.margins.right = window.margins.right - dx
                                window.margins.top = window.margins.top + dy

                                startX = mouse.x
                                startY = mouse.y
                            }
                        }
                    }
                }

                Column {
                    anchors.fill: parent
                    anchors.margins: 20
                    anchors.topMargin: 74
                    spacing: 12

                    ScrollView {
                        width: parent.width
                        height: parent.height - 35
                        clip: true

                        TextArea {
                            id: noteText
                            placeholderText: "Type here…"
                            wrapMode: TextEdit.Wrap
                            font.pixelSize: 17
                            color: "#2c2c2c"
                            background: null
                            selectByMouse: true
                            focus: root.shown

                            onTextChanged: {
                                if (root.noteLoaded) {
                                    saveTimer.restart()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: saveTimer
        interval: 800
        repeat: false
        onTriggered: saveNote()
    }

    onShownChanged: {
        if (!shown && root.noteLoaded) {
            saveNote()
        }
    }
}
