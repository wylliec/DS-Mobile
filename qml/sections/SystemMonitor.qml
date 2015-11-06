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

Item {
    Component.onCompleted: reset()

    function reset() {
        cpuUsage.subText = "--.--"
        ramUsage.subText = "--.--"
        diskUsage.subText = "--.--"
        batteryVoltage.subText = "--.--"
    }

    Connections {
        target: c_ds
        onCommunicationsChanged: reset()
        onRamUsageChanged: ramUsage.subText = qsTr ("%1%").arg (data)
        onCpuUsageChanged: cpuUsage.subText = qsTr ("%1%").arg (data)
        onDiskUsageChanged: diskUsage.subText = qsTr ("%1%").arg (data)
        onVoltageChanged: batteryVoltage.subText = qsTr ("%1 V").arg (data)
    }

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
                text:  "System Monitor"
            } ListItem.Divider {}

            /*
             * Battery Voltage
             */
            ListItem.Subtitled {
                id: batteryVoltage
                iconName: "device/battery_std"
                text: qsTr ("Battery Voltage")
            }

            /*
             * RAM Usage
             */
            ListItem.Subtitled {
                id: ramUsage
                iconName: "hardware/memory"
                text: qsTr ("RAM Usage")
            }

            /*
             * CPU Usage
             */
            ListItem.Subtitled {
                id: cpuUsage
                iconName: "action/settings"
                text: qsTr ("CPU Usage")
            }

            /*
             * Disk usage
             */
            ListItem.Subtitled {
                id: diskUsage
                iconName: "device/storage"
                text: qsTr ("Disk Usage")
            }
        }
    }
}
