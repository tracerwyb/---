//#include "mainwindow.h"
#include <QApplication>
#include <QQmlApplicationEngine>
#include "addfriendpagecontroller.h"
#include "client.h"
#include "communicationpagecontroller.h"
#include "messagepreviewpagecontroller.h"
#include "network.h"
#include "personalpagecontroller.h"
#include <arpa/inet.h>
#include <iostream>
#include <netinet/in.h>
#include <string.h>
#include <sys/socket.h>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    qmlRegisterType<MessagePreviewPageController>("UIControl", 1, 0, "MessagePreviewPageController");
    qmlRegisterType<CommunicationPageController>("UIControl", 1, 0, "CommunicationPageController");
    qmlRegisterType<PersonalPageController>("UIControl", 1, 0, "PersonalPageController");

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<AddFriendPageController>("UIControl", 1, 0, "AddFriendPageController");
    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    AddFriendPageController add;
    add.setAddFri(1);

    engine.load(url);
    // Network network;
    // Client client;
    // network.createSocket();

    // while (1) {
    //     int choice;
    //     int retval;
    //     retval = network.Select();
    //     std::cout << "retval:" << retval << std::endl;
    //     if (retval == 1) {
    //         network.reciveTextMessage();
    //     }
    //     std::cout << "If you want send msg,please input 1" << std::endl;
    //     std::cin >> choice;
    //     if (choice == 1) {
    //         char *buf = client.Messagedata();
    //         std::cout << "main():" << buf;
    //         qDebug() << "buf len" << strlen(buf);
    //         network.sendTextMessage(buf, strlen(buf));
    //     }
    // }
    // network.closeSocket();

    return app.exec();
}
