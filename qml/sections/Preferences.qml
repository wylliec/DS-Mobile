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
import "../widgets"
import "../interfaces"

SmartPage {
    id: page

    View {
        id: view
        elevation: 1
        anchors.centerIn: parent
        anchors.margins: Units.dp (32)

        width: {
            if (showAsMobile)
                return page.width - Units.dp (32)

            return widgets.implicitWidth + Units.dp (32)
        }

        height: widgets.implicitHeight + Units.dp (32)

        Column {
            id: widgets
            width: widgetWidth
            anchors.centerIn: parent

            /*
             * Section header
             */
            Label {
                style: "body2"
                text:  "Networking Settings"
            } ListItem.Divider {}

            /*
             * Custom robot address
             */
            ListItem.SimpleMenu {
                subText: robotAddress.value
                text: qsTr ("Robot Address")
                onClicked: robotAddress.show()
                iconName: "device/developer_mode"
            }

            /*
             * Team number
             */
            ListItem.Subtitled {
                iconName: "content/flag"
                subText: teamNumber.value
                text: qsTr ("Team number")
                onClicked: teamNumber.show()
            }

            /*
             * Section header
             */
            Label {
                style: "body2"
                text:  "Other options"
            } ListItem.Divider {}

            /*
             * Team number
             */
            ListItem.Subtitled {
                iconName: "image/color_lens"
                onClicked: colorPicker.show()
                text: qsTr ("Change Appearance")
            }

            /*
             * Buttons
             */
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

    /*
     * Team number dialog
     */
    InputDialog {
        id: teamNumber
        value: Settings.teamNumber
        title: qsTr ("Input team number")
        onAccepted: {
            Settings.setTeamNumber (value)
            robotAddress.value = Settings.address()
        }
    }

    /*
     * Custom network address dialog
     */
    InputDialog {
        id: robotAddress
        value: Settings.address()
        title: qsTr ("Robot Address")
        onAccepted: Settings.setRobotAddress (value)
    }

    /*
     * Reset settings dialog
     */
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

    /*
     * Changes color settings
     */
    ColorPicker {
        id: colorPicker
    }
}
