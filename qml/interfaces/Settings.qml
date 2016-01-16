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

pragma Singleton

Object {
    id: settings

    /* Driver Station stuff */
    property int teamNumber: c_settings.getNumber ("Team", 3223)
    property int position: c_settings.getNumber ("Position", 0)
    property bool allianceIsBlue: c_settings.getBool ("Blue", false)
    property string robotAddress: c_settings.get ("Address", "10.32.23.22")
    property bool firstLaunch: c_settings.getBool ("First Launch", true)

    /* Window-related stuff */
    property int x: c_settings.getNumber ("x", 0)
    property int y: c_settings.getNumber ("y", 0)
    property int width: c_settings.getNumber ("width", Units.dp (800))
    property int height: c_settings.getNumber ("height", Units.dp (600))

    /* Theming stuff */
    property string accentColor: c_settings.get ("Accent", "blueGrey")
    property string primaryColor: c_settings.get ("Primary", "blueGrey")

    /* Used to avoid loading settings more than one time */
    property bool m_init: false

    Component.onCompleted: updateAppAppearance()

    /*
     * Applies saved settings
     */
    function loadSettings() {
        if (!m_init) {
            m_init = true
            updateDriverStationConfig()
        }
    }

    /*
     * Re-configures the DS with current settings
     */
    function updateDriverStationConfig() {
        c_ds.init()
        c_ds.setTeamNumber (teamNumber)
        c_ds.setCustomAddress (robotAddress)
        c_ds.addJoystick(3,12,1);
        c_ds.addJoystick(3,12,1);
        updateAlliance()
    }

    /*
     * Returns the robot address (auto or manual)
     */
    function address() {
        if (robotAddress.length < 1)
            return c_ds.robotAddress()

        return robotAddress
    }

    /*
     * Changes the alliance of the Driver Station to
     * match the alliance and position referenced in the settings
     */
    function updateAlliance() {
        /* Blue alliance */
        if (allianceIsBlue) {
            switch (position) {
            case 0:
                c_ds.setAlliance (c_ds.kAllianceBlue1)
                break
            case 1:
                c_ds.setAlliance (c_ds.kAllianceBlue2)
                break
            case 2:
                c_ds.setAlliance (c_ds.kAllianceBlue3)
                break
            default:
                c_ds.setAlliance (c_ds.kAllianceBlue1)
                break
            }
        }

        /* Red alliance */
        else {
            switch (position) {
            case 0:
                c_ds.setAlliance (c_ds.kAllianceRed1)
                break
            case 1:
                c_ds.setAlliance (c_ds.kAllianceRed2)
                break
            case 2:
                c_ds.setAlliance (c_ds.kAllianceRed3)
                break
            default:
                c_ds.setAlliance (c_ds.kAllianceRed1)
                break
            }
        }
    }

    /*
     * Changes the theme of the application
     */
    function updateAppAppearance() {
        Theme.tabHighlightColor = "#fff"
        Theme.accentColor = Palette.colors [accentColor]["600"]
        Theme.primaryColor = Palette.colors [primaryColor]["600"]
        Theme.primaryDarkColor = Palette.colors [primaryColor]["700"]
    }

    /*
     * Saves the team number and configures the DS
     */
    function setTeamNumber (team) {
        teamNumber = team
        updateDriverStationConfig()
        c_settings.set ("Team", teamNumber)
    }

    /*
     * Saves the address and configures the DS
     */
    function setRobotAddress (address) {
        robotAddress = address
        updateDriverStationConfig()
        c_settings.set ("Address", robotAddress)
    }

    function setFirstLaunch (bool) {
        firstLaunch = bool
        c_settings.set ("First Launch", firstLaunch)
    }

    /*
     * Saves the accent color and updates the app
     */
    function setAccentColor (color) {
        accentColor = color
        updateAppAppearance()
        c_settings.set ("Accent", color)
    }

    /*
     * Saves the primary color and updates the app
     */
    function setPrimaryColor (color) {
        primaryColor = color
        updateAppAppearance()
        c_settings.set ("Primary", color)
    }

    /*
     * Saves window x-position
     */
    function setX (value) {
        x = value
        c_settings.set ("x", x)
    }

    /*
     * Saves window y-position
     */
    function setY (value) {
        y = value
        c_settings.set ("y", y)
    }

    /*
     * Saves window width
     */
    function setWidth (value) {
        width = value
        c_settings.set ("width", width)
    }

    /*
     * Saves window height
     */
    function setHeight (value) {
        height = value
        c_settings.set ("height", height)
    }

    /*
     * Resets application colors & address
     */
    function reset() {
        robotAddress = ""
        accentColor = "blueGrey"
        primaryColor = "blueGrey"

        c_settings.set ("Address", robotAddress)
        c_settings.set ("Accent color", accentColor)
        c_settings.set ("Primary color", primaryColor)

        updateAppAppearance()
        updateDriverStationConfig()
    }
}
