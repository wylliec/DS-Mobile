# QDriverStation Mobile

[![Build Status](https://travis-ci.org/WinT-3794/DS-Mobile.svg?branch=master)](https://travis-ci.org/WinT-3794/DS-Mobile)
[![BitCoin donate button](https://img.shields.io/badge/bitcoin-donate-yellow.svg)](https://blockchain.info/address/1K85yLxjuqUmhkjP839R7C23XFhSxrefMx "Donate once-off to this project using BitCoin")

[![Screenshot](/etc/screenshots/Main_small.jpg)](etc/screenshots/)

### Introduction

QDriverStation Mobile is an open-source, cross-platform alternative to the FRC Driver Station. It implements the capabilities that you would expect from the FRC Driver Station in a touch-friendly interface.

The actual code that moves and manages a FRC robot is found in a [separate repository](https://github.com/WinT-3794/LibDS), which you can use in your own Qt projects or change it to support older (and future) communication protocols. 

Click [here](https://github.com/wint-3794/qdriverstation) for the **desktop** version!

### Build instructions

###### Requirements

The only requirement to compile the application is to have [Qt](http://www.qt.io/download-open-source/) installed. The application requires you to have at least Qt 5.2 installed.

###### Compiling

Once you have Qt installed, open *Mobile.pro* in Qt Creator and click the "Run" button.

Alternatively, you can also use the following commands:
- qmake
- make
- **Optional:** sudo make install

### Credits

This application was created by FRC team 3794 "WinT" from Metepec, Mexico. We sincerely hope that you enjoy our application and we would love some feedback from your team about it.

We would also like to thank the [Papyros team](https://github.com/papyros/) for implementing the [Material design](https://github.com/papyros/qml-material) in QML. Without their work, the UI of this application would have been very ugly.
