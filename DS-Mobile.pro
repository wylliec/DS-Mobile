#
# Copyright (c) 2015 WinT 3794 <http://wint3794.org>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

#-------------------------------------------------------------------------------
# Deploy configuration
#-------------------------------------------------------------------------------

TARGET = QDriverStation

win32* {
    LIBS += -lPdh
    RC_FILE = $$PWD/etc/deploy/windows/info.rc
}

macx* {
    ICON = $$PWD/etc/deploy/mac-osx/AppIcon.icns
    RC_FILE = $$PWD/etc/deploy/mac-osx/AppIcon.icns
    QMAKE_INFO_PLIST = $$PWD/etc/deploy/mac-osx/Info.plist
}

linux:!android {
    target.path = /usr/bin
    TARGET = qdriverstation
    icon.path = /usr/share/pixmaps
    desktop.path = /usr/share/applications
    icon.files += $$PWD/etc/deploy/linux/qdriverstation.ico
    desktop.files += $$PWD/etc/deploy/linux/qdriverstation.desktop
    INSTALLS += target desktop icon
}

linux:android {
    DISTFILES += \
        $$PWD/etc/deploy/android/AndroidManifest.xml \
        $$PWD/etc/deploy/android/res/values/libs.xml \
        $$PWD/etc/deploy/android/build.gradle \
        $$PWD/etc/deploy/android/gradle/wrapper/gradle-wrapper.jar \
        $$PWD/etc/deploy/android/gradlew \
        $$PWD/etc/deploy/android/gradle/wrapper/gradle-wrapper.properties \
        $$PWD/etc/deploy/android/gradlew.bat

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/etc/deploy/android
    QT += androidextras
}

CONFIG += qtquickcompiler

#-------------------------------------------------------------------------------
# C++ build options
#-------------------------------------------------------------------------------

CODECFORTR = UTF-8
CODECFORSRC = UTF-8

CONFIG += c++11

UI_DIR = uic
MOC_DIR = moc
RCC_DIR = qrc
OBJECTS_DIR = obj

#-------------------------------------------------------------------------------
# Include the LibDS library
#-------------------------------------------------------------------------------

include ($$PWD/lib/LibDS/LibDS.pri)
include ($$PWD/lib/Material/Material.pri)

#-------------------------------------------------------------------------------
# Import resources and code
#-------------------------------------------------------------------------------

SOURCES += $$PWD/src/main.cpp \
           $$PWD/src/Settings.cpp
		   
HEADERS += $$PWD/src/Settings.h
RESOURCES += $$PWD/qml/qml.qrc

#-------------------------------------------------------------------------------
# Import QML
#-------------------------------------------------------------------------------

OTHER_FILES += $$PWD/qml/*.qml
OTHER_FILES += $$PWD/qml/dialogs/*.qml
OTHER_FILES += $$PWD/qml/sections/*.qml
OTHER_FILES += $$PWD/qml/widgets/*.qml
OTHER_FILES += $$PWD/qml/interfaces/*.qml
