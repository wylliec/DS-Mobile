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

#include "Settings.h"

int main (int argc, char* argv[])
{
    QApplication app (argc, argv);
    app.setOrganizationName ("WinT 3794");
    app.setApplicationName  ("QDriverStation Mobile");

    Settings* st = new Settings();
    DriverStation* ds = DriverStation::getInstance();

    QQmlApplicationEngine engine;
    engine.addImportPath ("qrc:/Material/modules/");
    engine.rootContext()->setContextProperty ("c_ds", ds);
    engine.rootContext()->setContextProperty ("c_settings", st);
    engine.load (QUrl (QStringLiteral ("qrc:/qml/main.qml")));

    return app.exec();
}
