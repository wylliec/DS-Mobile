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

#include <QUrl>
#include <QClipboard>
#include <QQmlContext>
#include <QApplication>
#include <DriverStation.h>
#include <QQmlApplicationEngine>

#include "Updater.h"
#include "Settings.h"

int main (int argc, char* argv[])
{
    QApplication app (argc, argv);
    app.setApplicationVersion ("0.13");
    app.setOrganizationName ("WinT 3794");
    app.setApplicationName  ("QDriverStation Mobile");

    Updater updater;
    Settings settings;
    DriverStation* ds = DriverStation::getInstance();
    ds->setProtocol (DriverStation::Protocol2015);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty ("c_ds", ds);
    engine.rootContext()->setContextProperty ("c_updater", &updater);
    engine.rootContext()->setContextProperty ("c_settings", &settings);

    engine.addImportPath ("qrc:/Material/modules/");
    engine.load (QUrl (QStringLiteral ("qrc:/qml/main.qml")));

    updater.checkForUpdates();

    return app.exec();
}
