TARGET = n9weather
TEMPLATE = app

QT += core gui declarative network

CONFIG += qdeclarative-boostable

SOURCES += main.cpp

# Kaynak dosyaların kurulum hedefleri
target.path = /opt/n9weather
INSTALLS += target

qml_files.path = /opt/n9weather/qml
qml_files.files = qml/*.qml qml/*.js
INSTALLS += qml_files

image_files.path = /opt/n9weather/images
image_files.files = images/*.png
INSTALLS += image_files

desktop.files = n9weather.desktop
desktop.path = /usr/share/applications
INSTALLS += desktop

icon.files = images/n9weather80.png
icon.path = /usr/share/icons/hicolor/80x80/apps
INSTALLS += icon
