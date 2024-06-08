//#include "mainwindow.h"
#include "addfriendpagecontroller.h"
#include "communicationpagecontroller.h"
#include "getfirstletter.h"
#include "messagepreviewpagecontroller.h"
#include "personalpagecontroller.h"
#include "listenthread.h"
#include "client.h"
#include "myimageprovider.h"
#include <QApplication>
#include <QQmlApplicationEngine>
#include "filetools.h"
// #include <libavformat/avformat.h>
#include <nlohmann/json.hpp>
#include <QQmlContext>


int main(int argc, char *argv[])
{

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    // qmlRegisterType<MessagePreviewPageController>("UIControl", 1, 0, "MessagePreviewPageController");
    // qmlRegisterType<CommunicationPageController>("UIControl", 1, 0, "CommunicationPageController");
    qmlRegisterType<PersonalPageController>("UIControl", 1, 0, "PersonalPageController");
    qmlRegisterType<GetFirstLetter>("Algorithm", 1, 0, "GetFirstLetter");
    qmlRegisterType<AddFriendPageController>("UIControl", 1, 0, "AddFriendPageController");

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    ListenThread listenThread;
    engine.rootContext()->setContextProperty("listenThread",&listenThread);

    MyImageProvider *myImageProvider = MyImageProvider::getInstance();
    engine.addImageProvider("pictures",myImageProvider);
    
    // MessagePreviewPageController messagePreviewPageController;
    // CommunicationPageController communicationPageController;

    engine.rootContext()->setContextProperty("messagePreviewPageController",
                                             MessagePreviewPageController::getInstance());
    engine.rootContext()->setContextProperty("communicationPageController",
                                             CommunicationPageController::getInstance());
    engine.rootContext()->setContextProperty("fileTools", FileTools::getInstance());
    
    const QUrl url(QStringLiteral("qrc:/qml/InitPage.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);
    return app.exec();

}
