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
        lib.subText = "--.--"
        pdp.subText = "--.--"
        pcm.subText = "--.--"
    }

    Connections {
        target: c_ds
        onCommunicationsChanged: reset()
        onLibVersionChanged: lib.subText = data
        onPdpVersionChanged: pdp.subText = data
        onPcmVersionChanged: pcm.subText = data
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
                text:  "Software Versions"
            } ListItem.Divider {}

            /*
             * Library Version
             */
            ListItem.Subtitled {
                id: lib
                iconName: "action/code"
                text: qsTr ("FRC Library")
            }

            /*
             * PDP Version
             */
            ListItem.Subtitled {
                id: pdp
                iconName: "action/power_settings_new"
                text: qsTr ("Power Distribution Panel")
            }

            /*
             * PCM Version
             */
            ListItem.Subtitled {
                id: pcm
                iconName: "hardware/memory"
                text: qsTr ("Pneumatic Control Module")
            }
        }
    }
}
