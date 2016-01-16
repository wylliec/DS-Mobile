/*
 * Copyright (c) 2015 WinT 3794 <http://wint3794.org>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import QtQuick 2.4
import Material 0.1

Column {
    anchors {
        left: parent.left
        right: parent.right
    }

    Repeater {
        model: 2
        delegate: Column {
            Grid {
                spacing: 5
                columns: 6

                Repeater {
                    model: 12
                    delegate: Button {
                        text: qsTr ("" + (index + 1))
                        elevation: checked ? 0 : 1
                        width: 100
                        checkable: true

//                        onClicked: {
//                            c_ds.updateJoystickButton (js, index, checked)
//                            snackbar.open (qsTr ("joystick #" + (js + 1) + " button #" + (index + 1) + (checked ? " clicked" : " unclicked" )))
//                        }

                        onPressedChanged: {
                            checked = pressed
                            c_ds.updateJoystickButton (js, index, pressed)
                            snackbar.open (qsTr ("joystick #" + (js + 1) + " button #" + (index + 1) + (pressed ? " clicked" : " unclicked" )))
                        }
                    }
                }
            }

            Item {
                width:  Units.dp (10)
                height: Units.dp (10)
            }

            Repeater {
                model: 3
                delegate: Slider {
                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    minimumValue: -1.0

                    onValueChanged: {
                        if(Math.abs(value) < 0.1) {
                            value = 0
                        }

                        c_ds.updateJoystickAxis (js, index, value)
                        snackbar.open (qsTr ("joystick #" + (js + 1) + " slider #" + (index + 1) + " changed to " + value.toFixed(3)))
                    }
                }
            }

            property int js: index
        }
    }

//    Row {
//        spacing: 30

//        Repeater {
//            model: 2
//            delegate: Rectangle {
//                width: 300
//                height: width
//                color: "white"
//                radius: width*0.5

//                Rectangle {
//                    width: parent.width*0.5
//                    height: width
//                    color: "black"
//                    radius: width*0.5

//                    anchors.horizontalCenter: parent.horizontalCenter
//                    anchors.verticalCenter: parent.verticalCenter

//                    MouseArea {
//                        anchors.fill: parent

//                        function press (mouse) {
//                            parent.x = mouse.x
//                            parent.y = mouse.y
//                            parent.
//                            snackbar.open (qsTr ("joystick #" + (index + 1) + " pressed. x:" + mouse.x + ", y:" + mouse.y))
//                        }

//                        function change (mouse) {
//                            snackbar.open (qsTr ("joystick #" + (index + 1) + " changed. x:" + mouse.x + ", y:" + mouse.y))
//                        }

//                        function release (mouse) {
//                            snackbar.open (qsTr ("joystick #" + (index + 1) + " released"))
//                        }

//                        onPressed: press(mouse)
//                        onPositionChanged: change(mouse)
//                        onReleased: release(mouse)
//                    }
//               }
//           }
//        }
//    }
 }
