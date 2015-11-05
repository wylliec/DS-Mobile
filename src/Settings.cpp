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

#include "Settings.h"

Settings::Settings()
{
    m_settings = new QSettings (qApp->organizationName(),
                                qApp->applicationName());
}

Settings::~Settings()
{
    delete m_settings;
}

void Settings::set (QString key, QVariant value)
{
    m_settings->setValue (key, value);
}

QVariant Settings::get (QString key, QVariant defValue)
{
    return m_settings->value (key, defValue);
}

bool Settings::getBool (QString key, QString defValue)
{
    return get (key, defValue).toBool();
}

double Settings::getNumber (QString key, double defValue)
{
    return get (key, defValue).toDouble();
}

QString Settings::getString (QString key, QString defValue)
{
    return get (key, defValue).toString();
}
