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

import "../dialogs"
import "../interfaces"

Item {
    View {
        id: view
        elevation: 1

        anchors {
            left: parent.left
            right: parent.right
            margins: Units.dp (32)
            verticalCenter: parent.verticalCenter
        }

        height: column.implicitHeight + Units.dp (32)

        Column {
            id: column
            anchors.fill: parent
            anchors.margins: Units.dp (16)

            Label {
                style: "body2"
                text:  "Networking Settings"
            } ListItem.Divider {}

            ListItem.Subtitled {
                subText: robotAddress.value
                text: qsTr ("Robot Address")
                onClicked: robotAddress.show()
                iconName: "device/network_wifi"
            }

            ListItem.Subtitled {
                iconName: "content/flag"
                subText: teamNumber.value
                text: qsTr ("Team number")
                onClicked: teamNumber.show()
            }

            Label {
                style: "body2"
                text:  "Other options"
            } ListItem.Divider {}

            ListItem.Subtitled {
                iconName: "image/color_lens"
                onClicked: colorPicker.show()
                text: qsTr ("Change Appearance")
            }

            Item {
                height: reset.height
                anchors.left: parent.left
                anchors.right: parent.right

                Item {
                    anchors.left: parent.left
                    anchors.right: reset.left
                }

                Button {
                    id: reset
                    text: qsTr ("Reset")
                    onClicked: resetDialog.show()
                    anchors.right: parent.right
                }
            }
        }
    }

    InputDialog {
        id: teamNumber
        value: Settings.teamNumber
        title: qsTr ("Input team number")
        onAccepted: {
            Settings.setTeamNumber (value)
            robotAddress.value = Settings.address()
        }
    }

    InputDialog {
        id: robotAddress
        value: Settings.address()
        title: qsTr ("Robot Address")
        onAccepted: Settings.setRobotAddress (value)
    }

    Dialog {
        id: resetDialog
        title: qsTr ("Reset Settings")
        negativeButtonText: qsTr ("No")
        positiveButtonText: qsTr ("Yes")
        text: qsTr ("Are you sure you want to reset the preferences?")

        onAccepted: {
            Settings.reset()
            robotAddress.value = Settings.address()
        }
    }

    ColorPicker {
        id: colorPicker
    }
}
