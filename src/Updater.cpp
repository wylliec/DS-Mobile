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

#include "Updater.h"

Updater::Updater()
{
    m_version = "";
    m_platform = "";
    m_downloadLink = "";
    m_updateAvailable = false;

#if defined Q_OS_WIN
    m_platform = "windows";
#elif defined Q_OS_MAC
    m_platform = "macintosh";
#elif defined Q_OS_LINUX
    m_platform = "linux";
#elif defined Q_OS_ANDROID
    m_platform = "android";
#elif defined Q_OS_IOS
    m_platform = "ios";
#endif

    connect (&m_accessManager, SIGNAL (finished   (QNetworkReply*)),
             this,             SLOT   (onFinished (QNetworkReply*)));
}

void Updater::checkForUpdates()
{
    QString url = "https://raw.githubusercontent.com/"
                  "WinT-3794/QDriverStation/updater/current";

    m_accessManager.get (QNetworkRequest (QUrl (url)));
}

void Updater::showUpdateMessages()
{
    bool alreadyShown = m_settings.get (m_version, false).toBool();

    if (m_updateAvailable && !alreadyShown) {
        m_settings.set (m_version, true);
        emit updateAvailable (m_version, m_downloadLink);
    }
}

void Updater::onFinished (QNetworkReply* reply)
{
    QByteArray data = reply->readAll();

    readDownloadLink (data);
    readApplicationVersion (data);
    showUpdateMessages();

    delete reply;
}

void Updater::readDownloadLink (QByteArray data)
{
    m_downloadLink = readKey (QString::fromUtf8 (data),
                              QString ("download-%1").arg (m_platform));
}

void Updater::readApplicationVersion (QByteArray data)
{
    m_updateAvailable = false;
    m_version = readKey (QString::fromUtf8 (data),
                         QString ("latest-%1").arg (m_platform));

    QStringList online = m_version.split (".");
    QStringList local  = qApp->applicationVersion().split (".");

    /* Figure out if local version is smaller than online version */
    for (int i = 0; i <= online.count() - 1; ++i) {
        if (online.count() - 1 >= i && local.count() - 1 >= i) {
            if (online.at (i) > local.at (i)) {
                m_updateAvailable = true;
                return;
            }
        }

        else if (local.count() < online.count()) {
            if (local.at (i - 1) == online.at (i - 1))
                break;

            else {
                m_updateAvailable = true;
                return;
            }
        }
    }
}

QString Updater::readKey (QString data, QString key)
{
    QString value;
    int startIndex = -1;
    int finishIndex = -1;

    if (data.isEmpty() || key.isEmpty())
        return value;

    startIndex = data.indexOf (QString ("<%1>").arg (key));
    finishIndex = data.indexOf (QString ("</%1>").arg (key));

    if (startIndex != -1 && finishIndex != -1) {
        for (int i = startIndex + key.length() + 2; i < finishIndex; ++i)
            value.append (data.at (i));
    }

    return value;
}
