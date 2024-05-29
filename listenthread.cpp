#include "listenthread.h"
#include "client.h"
#include "nlohmann/json.hpp"
#include "personalpagecontroller.h"

ListenThread::ListenThread(QObject *parent):QThread(parent),state(true)
{

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
        qDebug()<<"begin to read";
        int n=Client::getInstance()->receive(buf);
        qDebug()<<"read ok"<<n;

        if(n == -1){
            qDebug()<<"listenthread read failed!";
            break;
        }
        //从将套接字内容读到了buf中，下接转json存储
        auto j=nlohmann::json::parse(buf);
        std::string content;
        content=j.at("content");
        PersonalPageController::setAcceptmsg(content);
    }

    qDebug()<<"the listen thread finish work";

    emit finish();
}
