#include "listenthread.h"
#include "client.h"
#include <nlohmann/json.hpp>
using nlohmann::json;

ListenThread::ListenThread(QObject *parent)
    : QThread(parent)
    , state(true)
    , m_afc{new AddFriendPageController()}
{
    startThread();
}

void ListenThread::startThread()
{
    if(!isRunning()){
        start();
    }
}

void ListenThread::stopThread()
{
    if(isRunning()){
        qDebug()<<"thread over!";
        state=false;
    }
}

void ListenThread::run()         //子线程：从套接字中读数据,点击登陆时调用该类的方法startThread（）
{
    qDebug()<<"the listen thread begin work";
    while (state) {
        char buf[10240];      //待修改
        bzero(buf,sizeof(buf));
        qDebug() << "client";
        Client::getInstance()->start();
        int n = Client::getInstance()->receive(buf);

        if(n == -1){
            qDebug()<<"listenthread read failed!";
        }
        //从将套接字内容读到了buf中，下接转json存储
        json j = json::parse(buf);
        if (j.at("request_type") == "user_info") {
            m_afc->receiveFriBaseInfo(buf);
        }
        if (j.at("request_type") == "addfriend") {
            m_afc->receiveAddRequest(buf);
        }
        if (j.at("request_type") == "acceptfrinfo") {
            m_afc->receiveAcceptSignal(buf);
        }
    }

    qDebug()<<"the listen thread finish work";

    emit finish();
}
