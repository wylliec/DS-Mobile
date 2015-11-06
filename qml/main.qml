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

import "dialogs"
import "interfaces"

ApplicationWindow {
    id: app
    visible: true
    Component.onCompleted: {
        Units.gridUnit = Units.dp (56)
        showMaximized()
    }

    /*
     * Sections of the general tab
     */
    property var general: [
        qsTr ("Robot Control"),
        qsTr ("Diagnostics"),
        qsTr ("Preferences")
    ]

    /*
     * Sections of the information tab
     */
    property var robotInformation: [
        qsTr ("NetConsole"),
        qsTr ("Software Versions"),
        qsTr ("System Monitor")
    ]

    /*
     * Define the sections and their respective titles
     */
    property string selectedComponent: general [0]
    property var sections: [ general, robotInformation ]
    property var sectionTitles: [ qsTr ("General"), qsTr ("Robot Information") ]

    /*
     * The main page
     */
    initialPage: TabbedPage {
        id: page
        title: "QDriverStation"
        backAction: navDrawer.action

        /*
         * The sidebar that allows us to choose the program sections
         */
        NavigationDrawer {
            id: navDrawer
            enabled: page.width < Units.dp(500)

            /*
             * Create a list with the sections
             */
            Flickable {
                anchors.fill: parent
                contentHeight: Math.max (content.implicitHeight, height)

                Column {
                    id: content
                    anchors.fill: parent

                    Repeater {
                        model: sections

                        delegate: Column {
                            width: parent.width

                            ListItem.Subheader {
                                text: sectionTitles[index]
                            }

                            Repeater {
                                model: modelData
                                delegate: ListItem.Standard {
                                    text: modelData
                                    selected: modelData === app.selectedComponent
                                    onClicked: {
                                        app.selectedComponent = modelData
                                        navDrawer.close()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        /*
         * Create a selectable item for each section
         */
        Repeater {
            model: !navDrawer.enabled ? sections : 0
            delegate: Tab {
                title: sectionTitles [index]
                sourceComponent: tabDelegate

                property var section: modelData
                property string selectedComponent: modelData[0]
            }
        }

        Loader {
            anchors.fill: parent
            visible: navDrawer.enabled
            sourceComponent: tabDelegate

            property var section: []
        }
    }

    Component {
        id: tabDelegate

        Item {
            Sidebar {
                id: sidebar
                expanded: !navDrawer.enabled

                Column {
                    width: parent.width

                    Repeater {
                        model: section
                        delegate: ListItem.Standard {
                            text: modelData
                            selected: modelData == selectedComponent
                            onClicked: selectedComponent = modelData
                        }
                    }
                }
            }

            /*
             * Shows the section in a scrollable area
             */
            Flickable {
                id: flickable
                anchors {
                    left: sidebar.right
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                }

                clip: true
                contentHeight: Math.max (currentSection.implicitHeight + 40, height)

                /*
                 * Loads the selected section
                 */
                Loader {
                    id: currentSection
                    asynchronous: true
                    anchors.fill: parent
                    source: "qrc:/qml/sections/" + selectedComponent.replace (" ", "") + ".qml"
                }
            }

            /*
             * Implements a scrollbar that moves the flickable item
             */
            Scrollbar {
                flickableItem: flickable
            }
        }
    }

    /*
     * The about dialog, can I say something more?
     */
    About {
        id: about
    }

    /*
     * Team number dialog (used for first launch)
     */
    InputDialog {
        id: firstLaunch
        negativeButtonText: ""
        negativeButton.enabled: false
        title: qsTr ("Input team number")
        Component.onCompleted: if (Settings.firstLaunch === true) show()

        onAccepted: {
            if (Settings.firstLaunch === true) {
                Settings.setTeamNumber (value)
                Settings.setFirstLaunch (false)
            }
        }
    }
}
