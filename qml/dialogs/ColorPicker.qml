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

import "../interfaces"

Dialog {
    id: colorPicker
    title: qsTr ("Pick color")

    positiveButtonText: qsTr ("Done")
    negativeButtonText: qsTr ("")
    negativeButton.enabled: false

    MenuField {
        id: selection
        width: Units.dp (160)
        model: [qsTr ("Primary color"), qsTr ("Accent color")]
    }

    Grid {
        columns: 7
        spacing: Units.dp (8)

        Repeater {
            model: [
                "red", "pink", "purple", "deepPurple", "indigo",
                "blue", "lightBlue", "cyan", "teal", "green",
                "lightGreen", "lime", "yellow", "amber", "orange",
                "deepOrange", "grey", "blueGrey", "brown"
            ]

            Rectangle {
                width: Units.dp(30)
                height: Units.dp(30)
                radius: Units.dp(2)
                color: Palette.colors [modelData]["600"]
                border.width: modelData === "white" ? Units.dp(2) : 0
                border.color: Theme.alpha ("#000", 0.26)

                Ink {
                    anchors.fill: parent

                    onPressed: {
                        switch(selection.selectedIndex) {
                        case 0:
                            Settings.setPrimaryColor (modelData)
                            break;
                        case 1:
                            Settings.setAccentColor (modelData)
                            break;
                        }
                    }
                }
            }
        }
    }
}
