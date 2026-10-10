#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys, os
from PySide.QtCore import QUrl, Qt
from PySide.QtGui import QApplication
from PySide.QtDeclarative import QDeclarativeView

def main():
    app = QApplication(sys.argv)
    app.setApplicationName("n9weather")
    app.setOrganizationName("meego.community")

    view = QDeclarativeView()
    base_path = os.path.dirname(os.path.abspath(__file__))
    qml_file = os.path.join(base_path, "qml", "main.qml")
    if not os.path.exists(qml_file):
        qml_file = "/opt/n9weather/qml/main.qml"

    view.setSource(QUrl.fromLocalFile(qml_file))
    view.setResizeMode(QDeclarativeView.SizeRootObjectToView)
    view.setAttribute(Qt.WA_OpaquePaintEvent)
    view.setAttribute(Qt.WA_NoSystemBackground)
    view.showFullScreen()

    return app.exec_()

if __name__ == "__main__":
    sys.exit(main())
