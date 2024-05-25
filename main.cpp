//#include "mainwindow.h"
#include <QApplication>
#include <QQmlApplicationEngine>
#include "client.h"
#include "network.h"
#include <arpa/inet.h>
#include <iostream>
#include <netinet/in.h>
#include <string.h>
#include <sys/socket.h>

#include "messagepreviewpagecontroller.h"
#include <libavformat/avformat.h>
#include <nlohmann/json.hpp>
int main(int argc, char *argv[])
{

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    qmlRegisterType<MessagePreviewPageController>("UIControl", 1, 0, "MessagePreviewPageController");

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

    /*
    Network network;
    Client client;
    network.createSocket();

        while (1) {
        int choice;
        int retval;
        retval=network.Select();
        std::cout<<"retval:"<<retval<<std::endl;
        if(retval==1){
            network.reciveTextMessage();
        }
        std::cout<<"If you want send msg,please input 1"<<std::endl;
        std::cin>>choice;
        if(choice==1){
            char* buf=client.Messagedata();
            std::cout<<"main():"<<buf;
            qDebug()<<"buf len"<<strlen(buf);
            network.sendTextMessage(buf,strlen(buf));
        }
    }
    network.closeSocket();
*/
    //模拟客户端接收到的消息且消息是一条一条发送过来的
    // std::vector<nlohmann::json> message_json;
    // 创建一个 JSON 对象模板
    nlohmann::json jsonTemplateText = {{"sender", "11111"},
                                       {"receiver", "22222"},
                                       {"messagecontent", "string"},
                                       {"messagetype", "Text"},
                                       {"sendtime", "2024-5-21 21:00"}};

    MessagePreviewPageController m;
    std::cout << "1111";
    return app.exec();
}

