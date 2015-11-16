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
import Material.ListItems 0.1 as ListItem

import "../widgets"
import "../interfaces"

Item {
    Component.onCompleted: {
        disableRobot()
        Settings.loadSettings()
    }

    function enableRobot() {
        button.checked = true

        switch (controlModes.selectedIndex)
        {
        case 0:
            controls.hide()
            c_ds.setControlMode (1)
            break
        case 1:
            c_ds.setControlMode (2)
            break
        case 2:
            c_ds.setControlMode (3)
            break
        case 3:
            c_ds.setControlMode (4)
            break
        default:
            disableRobot()
            break
        }
    }

    function disableRobot() {
        controls.show()
        button.checked = false
        c_ds.setControlMode (0)
    }

    Connections {
        target: c_ds
        onCodeChanged: code.available = available
        onCommunicationsChanged: communications.available = available
    }

    Snackbar {
        z: 1
        id: snackbar
    }

    Column {
        id: controls

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: Units.dp (20)
        }

        function hide() {
            height = 0
            opacity = 0
        }

        function show() {
            opacity = 1
            height = implicitHeight
        }

        Behavior on opacity {NumberAnimation{}}

        Label {
            style: "body2"
            text:  "Robot/Client Status"
        }

        ListItem.Divider {}

        ListItem.Subtitled {
            id: communications
            text: qsTr ("Communications")
            iconName: "action/settings_input_antenna"
            subText: available ? qsTr ("Established") : qsTr ("Failing")
            subTextColor: Palette.colors [available ? "green" : "red"] ["500"]

            property bool available: false
        }

        ListItem.Subtitled {
            id: code
            iconName: "action/code"
            text: qsTr ("Robot code")
            subText: available ? qsTr ("Code loaded") : qsTr ("Code not found")
            subTextColor: Palette.colors [available ? "green" : "red"] ["500"]

            property bool available: false
        }

        Item {
            width:  Units.dp (8)
            height: Units.dp (8)
        }

        Label {
            style: "body2"
            text:  "Control Options"
        }

        ListItem.Divider {}

        ListItem.SimpleMenu {
            id: controlModes
            iconName: "action/build"
            text: qsTr ("Control Mode")
            subText: model [selectedIndex]

            onSelectedIndexChanged: disableRobot()

            model: [
                qsTr ("TeleOperated"),
                qsTr ("Autonomous"),
                qsTr ("Test Mode"),
                qsTr ("Emergency Stop")
            ]
        }

        Item {
            id: allianceSelector

            anchors.left: parent.left
            anchors.right: parent.right

            height: positionList.height

            Button {
                id: colorBt
                elevation: 1
                checkable: true
                iconName: "action/bookmark"
                checked: Settings.allianceIsBlue
                text: checked ? qsTr ("Blue") : qsTr ("Red")
                backgroundColor: Palette.colors [checked ? "blue" : "red"]["500"]

                anchors {
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }
            }

            ListItem.SimpleMenu {
                id: positionList
                text: qsTr ("Position")
                iconName: "maps/my_location"
                subText: model [selectedIndex]
                selectedIndex: Settings.position

                model: ["1", "2", "3"]

                anchors {
                    left: colorBt.right
                    right: parent.right
                    leftMargin: Units.dp (8)
                    verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Button {
        id: button
        elevation: 1
        checkable: true
        text: checked ? qsTr ("Disable") : qsTr ("Enable")
        backgroundColor: checked ? Palette.colors ["red"]["500"] : Theme.primaryColor

        anchors {
            left: parent.left
            right: parent.right
            top: controls.bottom
            margins: Units.dp (20)
            topMargin: controls.height > 0 ? Units.dp (20) : Units.dp (0)
        }

        onClicked: {
            if (c_ds.canBeEnabled() && checked)
                enableRobot()

            else {
                disableRobot()
                snackbar.open (qsTr ("Cannot enable robot with current conditions"))
            }
        }
    }
}
