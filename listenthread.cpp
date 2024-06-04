#include "listenthread.h"
#include "client.h"
#include "communicationpagecontroller.h"
#include "filetools.h"
#include "nlohmann/json.hpp"
#include "personalpagecontroller.h"
#include "myimageprovider.h"

using nlohmann::json;

ListenThread::ListenThread(QObject *parent)
    : QThread(parent)
    , state(true)
    , m_afc{new AddFriendPageController()}
    , m_mfc{new MessagePreviewPageController()}
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
//------z j test ,ok can delete
        if(j.at("request_type") == "sendmsg"){
            std::string content;
            content=j.at("content");
            PersonalPageController::setAcceptmsg(content);
        }
        if(j.at("request_type") == "initPersonalPage"){
            if(j.at("imageName") == "avater"){
                MyImageProvider::getInstance()->setAvater(Client::getInstance()->receiveImage());
            }
        }
        if(j.at("request_type") == "sendimage"){
            MyImageProvider::getInstance()->setAvater(Client::getInstance()->receiveImage());
            qDebug()<<"set avater succeed!!!!!!!!!!";
        }
//--------

        if (j.at("request_type") == "isfriend") {
            AddFriendPageController::isFriend(buf);
        }

        if (j.at("request_type") == "user_info") {
            AddFriendPageController::receiveFriBaseInfo(buf);
        }

        if (j.at("request_type") == "addfriend") {
            AddFriendPageController::receiveAddRequest(buf);
        }

        if (j.at("request_type") == "acceptfrinfo") {
            AddFriendPageController::receiveAcceptSignal(buf);
        }

        if (j["request_type"] == "GetOfflineMessage") {
            std::string senderId;
            //json格式转换
            qDebug() << "store 1";
            if (j["SenderId"].is_number()) {
                senderId = std::to_string(j["SenderId"].get<int>());
            } else if (j["SenderId"].is_string()) {
                senderId = j["SenderId"].get<std::string>();
            } else {
                qDebug() << "SenderId is neither number nor string";
            }

            std::string receiverId;
            if (j["ReceiverId"].is_number()) {
                receiverId = std::to_string(j["ReceiverId"].get<int>());
            } else if (j["ReceiverId"].is_string()) {
                receiverId = j["ReceiverId"].get<std::string>();
            } else {
                qDebug() << "SenderId is neither number nor string";
            }
            QString filename = QString::fromStdString(senderId)
                               + QString::fromStdString(receiverId);
            qDebug() << "接收离线消息";
            if (j["MessageType"] == "Vedio" || j["MessageType"] == "Audio"
                || j["MessageType"] == "Picture") {
                char mediaBuffer[99999];
                int n = Client::getInstance()->receive(mediaBuffer);
                qDebug() << "接收离线消息音视频、图片";
                if (n == -1) {
                    qDebug() << "listenthread read failed!";
                    break;
                }
                qDebug() << "接收离线消息成功，准备存储";
                j = FileTools::getInstance()->saveMessageMedia(j, mediaBuffer, filename);
            } else {
                qDebug() << j.dump();
                qDebug() << "接收离线消息成功，准备存储";
                std::string strtemp(buf);
                FileTools::getInstance()->saveMessageText(j, filename);
            }
        }
        if ((j["request_type"] == "SendMessage")) {
            qDebug() << "有新的消息发送过来";
            std::string senderId = j.at("SenderId");
            std::string receiverId = j.at("ReceiverId");
            QString filename = QString::fromStdString(senderId)
                               + QString::fromStdString(receiverId);
            FileTools::getInstance()->saveMessageText(j, filename);
            qDebug() << j.dump();
            qDebug() << "MessagePreviewPageController有新的消息发送过来";
            MessagePreviewPageController::getInstance()->getOnlineMessage(j);
            qDebug() << "CommunicationPageController有新的消息发送过来";
            CommunicationPageController::getInstance()->getOnlineMessage(j);       
        }
    }

    qDebug() << "the listen thread finish work";

    emit finish();
}
