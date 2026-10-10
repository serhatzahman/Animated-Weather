#include <QtGui/QApplication>
#include <QtDeclarative/QDeclarativeView>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setApplicationName("n9weather");
    app.setOrganizationName("meego.community");

    QDeclarativeView view;
    view.setSource(QUrl::fromLocalFile("/opt/n9weather/qml/main.qml"));
    view.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    view.setAttribute(Qt::WA_OpaquePaintEvent);
    view.setAttribute(Qt::WA_NoSystemBackground);
    view.showFullScreen();

    return app.exec();
}
