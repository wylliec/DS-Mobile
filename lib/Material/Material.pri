QT += gui
QT += qml
QT += svg
QT += quick
QT += widgets

RESOURCES += $$PWD/material.qrc

OTHER_FILES += \
    $$PWD/modules/Material/*.qml \
    $$PWD/modules/Material/Extras/*.qml \
    $$PWD/modules/Material/ListItems/*.qml \
    $$PWD/modules/QtQuick/Controls/Styles/Material/*.qml

QML_IMPORT_PATH += $$PWD/modules/
