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

SmartPage {
    id: page

    Component.onCompleted: joystick.hide()
    /*
     * Enables the robot and shows the joysticks
     */
    function enableRobot() {
        switch (controlModes.selectedIndex)
        {
            /* TeleOp, hide controls and show josyticks */
        case 0:
            joystick.show()
            controlCard.hide()
            c_ds.setControlMode (c_ds.Teleoperated)
            break

            /* Autonomous, just switch modes */
        case 1:
            c_ds.setControlMode (c_ds.Autonomous)
            break

            /* Test mode, just switch modes */
        case 2:
            c_ds.setControlMode (c_ds.Test)
            break

            /* E-Stop, just switch modes */
        case 3:
            c_ds.setControlMode (c_ds.EmergencyStop)
            break

            /* Do nothing */
        default:
            disableRobot()
            break
        }
    }

    /*
     * Disables the robot and hides the joysticks
     */
    function disableRobot() {
        joystick.hide()
        controlCard.show()
        c_ds.setControlMode (c_ds.Disabled)
    }

    /*
     * Returns \c true if the robot can be enabled
     */
    function canBeEnabled() {
        return communications.available && code.available
    }

    /*
     * Update UI when receiving signals from the DS
     */
    Connections {
        target: c_ds
        onCodeChanged: code.available = c_ds.robotHasCode()
        onCommunicationsChanged: communications.available = c_ds.networkAvailable()
    }

    /*
     * Shows 'notifications' to the user
     */
    Snackbar {
        z: 1
        id: snackbar
    }

    /*
     * Control widget
     */
    View {
        elevation: 1
        id: controlCard

        width:  {
            if (enableBt.elevation === 0)
                return enableBt.width

            else if (showAsMobile)
                return page.width - Units.dp (32)

            return widgets.implicitWidth + Units.dp (32)

        }

        height:  {
            if (enableBt.elevation === 0)
                return enableBt.height

            return widgets.implicitHeight + Units.dp (32)
        }

        anchors {
            margins: Units.dp (32)
            horizontalCenter: parent.horizontalCenter
            top: enableBt.elevation === 0 ? parent.top : undefined
            verticalCenter: enableBt.elevation === 0 ? undefined : parent.verticalCenter
        }

        function hide() {
            controlItems.hide()
            enableBt.elevation = 0
        }

        function show() {
            controlItems.show()
            enableBt.elevation = 1
        }

        Column {
            id: widgets
            spacing: Units.gu (0.3)
            anchors.centerIn: parent

            /*
             * Contains everything except the enable/disable button
             */
            Column {
                width: widgetWidth
                id: controlItems

                function show() {
                    opacity = 1
                    height = implicitHeight
                }

                function hide() {
                    height = 0
                    opacity = 0
                }

                Behavior on opacity {NumberAnimation{}}

                /*
                 * Section header
                 */
                Label {
                    style: "body2"
                    text:  "Robot/Client Status"
                } ListItem.Divider {}

                /*
                 * Communications switch
                 */
                ListItem.Subtitled {
                    id: communications
                    text: qsTr ("Communications")
                    iconName: "action/settings_input_antenna"
                    subText: available ? qsTr ("Established") : qsTr ("Failing")
                    subTextColor: Palette.colors [available ? "green" : "red"] ["500"]

                    property bool available: false
                }

                /*
                 * Code switch
                 */
                ListItem.Subtitled {
                    id: code
                    iconName: "action/code"
                    text: qsTr ("Robot code")
                    subText: available ? qsTr ("Code loaded") : qsTr ("Code not found")
                    subTextColor: Palette.colors [available ? "green" : "red"] ["500"]

                    property bool available: false
                }

                /*
                 * Spacer
                 */
                Item {
                    width:  Units.dp (8)
                    height: Units.dp (8)
                }

                /*
                 * Section header
                 */
                Label {
                    style: "body2"
                    text:  "Control Options"
                } ListItem.Divider {}

                /*
                 * Control mode selector
                 */
                ListItem.SimpleMenu {
                    id: controlModes
                    iconName: "action/build"
                    text: qsTr ("Control Mode")
                    subText: model [selectedIndex]

                    onSelectedIndexChanged: {
                        enableBt.checked = false
                        c_ds.setControlMode (c_ds.Disabled)
                    }

                    model: [
                        qsTr ("TeleOperated"),
                        qsTr ("Autonomous"),
                        qsTr ("Test Mode"),
                        qsTr ("Emergency Stop")
                    ]
                }


                /*
                 * Alliance selector
                 */
                Item {
                    id: allianceSelector

                    width: widgetWidth
                    height: positionList.height

                    /*
                     * The alliance color selector
                     */
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

                    /*
                     * The position selector
                     */
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

            /*
             * Enable/Disable button
             */
            Button {
                id: enableBt
                elevation: 1
                checkable: true
                anchors.horizontalCenter: parent.horizontalCenter
                text: checked ? qsTr ("Disable") : qsTr ("Enable")
                width: elevation === 0 ? page.width - Units.dp (64) : widgetWidth

                backgroundColor: checked && controlModes.selectedIndex === 0 ?
                                     Palette.colors ["red"]["500"] : Theme.primaryColor

                /*
                 * Notify the user when the robot cannot be enabled
                 */
                onCheckedChanged: {
                    if (!canBeEnabled() && checked) {
                        checked = false
                        snackbar.open (qsTr ("Robot cannot be enabled with current conditions"))
                    }

                    checked ? enableRobot() : disableRobot()
                }
            }
        }
    }

    /*
     * Represents a virtual joystick
     */
    Joystick {
        id: joystick

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: controlCard.bottom

            margins: Units.dp (32)
            topMargin: Units.dp (16)
        }
    }
}
