//#include "mainwindow.h"
#include "addfriendpagecontroller.h"
#include "communicationpagecontroller.h"
#include "getfirstletter.h"
#include "messagepreviewpagecontroller.h"
#include "personalpagecontroller.h"
#include "listenthread.h"
#include "client.h"
#include <QApplication>
#include <QQmlApplicationEngine>
// #include <libavformat/avformat.h>
#include <nlohmann/json.hpp>
#include <QQmlContext>
int main(int argc, char *argv[])
{

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    qmlRegisterType<MessagePreviewPageController>("UIControl", 1, 0, "MessagePreviewPageController");
    qmlRegisterType<CommunicationPageController>("UIControl", 1, 0, "CommunicationPageController");
    qmlRegisterType<PersonalPageController>("UIControl", 1, 0, "PersonalPageController");
    qmlRegisterType<GetFirstLetter>("Algorithm", 1, 0, "GetFirstLetter");
    qmlRegisterType<AddFriendPageController>("UIControl", 1, 0, "AddFriendPageController");


    ListenThread listenThread;

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("listenThread",&listenThread);

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

    engine.load(url);
    return app.exec();


    // Network network;
    // Client *client=Client::getInstance();
    // client->start();
    // //network.createSocket();
    // client->setId();
    // char recevebuf[1024]="";
    // while (1) {
    //     int choice;
    //     int retval;
    //     retval=client->select();
    //     std::cout<<"retval:"<<retval<<std::endl;
    //     if(retval==1){
    //         int n=client->receive(recevebuf);
    //         if(n<0){
    //             break;
    //         }
    //     }

    //     qDebug()<<"If you want send msg,please input 1";
    //     std::cin>>choice;
    //     std::cin.get();
    //     if(choice==1){
    //         client->setAcceptId();
    //         client->setRequestType();
    //         char* buf=client->Messagedata();
    //         char* json_buf=new char[1024];
    //         client->comversionJson(json_buf);
    //         client->send(json_buf,strlen(json_buf));
    //         delete[] json_buf;
    //     }
    // }
    // network.closeSocket();

}
