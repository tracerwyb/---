//#include "mainwindow.h"
#include "network.h"
#include "personalpagecontroller.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <iostream>
#include <string.h>
#include <QApplication>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<PersonalPageController>("PersonalControl", 1, 0, "PersonalController");

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
    app.exec();
    /*
    Network network;
    Client client;
    network.createSocket();
    client.setId();
    char *recevebuf[1024]="";
    while (1) {
        int choice;
        int retval;
        retval=network.Select();
        std::cout<<"retval:"<<retval<<std::endl;
        if(retval==1){
            int n=network.reciveTextMessage(recevebuf);
            if(n<0){
                break;
            }
        }

        qDebug()<<"If you want send msg,please input 1";
        std::cin>>choice;
        std::cin.get();
        if(choice==1){
            client.setAcceptId();
            client.setRequestType();
            char* buf=client.Messagedata();
            char* json_buf=new char[1024];
            client.comversionJson(json_buf);
            network.sendTextMessage(json_buf,strlen(json_buf));
            delete[] json_buf;
        }
    }
    network.closeSocket();
*/
}

