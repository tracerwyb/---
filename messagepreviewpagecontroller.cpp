#include "messagepreviewpagecontroller.h"

#include "client.h"
#include "filetools.h"
#include <iostream>
#include <string>
MessagePreviewPageController *MessagePreviewPageController::messagePreviewPageController;

MessagePreviewPageController *MessagePreviewPageController::getInstance()
{
    if (messagePreviewPageController == nullptr) {
        messagePreviewPageController = new MessagePreviewPageController();
    }
    return messagePreviewPageController;
}
MessagePreviewPageController::MessagePreviewPageController(QObject *parent) {}
//读取离线请求-》返回存储文件
void MessagePreviewPageController::getOfflineMessage()
{
    qDebug() << "请求服务端推送离线消息";
    nlohmann::json request;
    Client *client = Client::getInstance();
    qDebug() << "当前登陆的用户是" << myId;
    request["UserId"] = myId.toStdString();
    request["request_type"] = "GetOfflineMessage";
    std::string str = request.dump();
    char *json_buf = new char[1024];
    strcpy(json_buf, str.data());
    client->send(json_buf, strlen(json_buf)); //点击发送按钮后,调用send方法发送已经序列化的json字符串
    delete[] json_buf;
    qDebug() << "客户端获取服务端发送的消息";
}

void MessagePreviewPageController::getOnlineMessage(nlohmann::json newMessage)
{
    std::string objSenderId = newMessage.at("SenderId");
    qDebug() << "getOnlineMessage";
    std::string objReceiverId = newMessage.at("ReceiverId");
    qDebug() << "test 2";
    if (messages.size() == 0) {
        qDebug() << "这是用户收到的第一条消息";
    } else {
        int count = 0;
        qDebug() << "这是用户收到的第n条消息";
        for (QString &message : messages) {
            nlohmann::json obj1 = nlohmann::json::parse(message.toStdString());
            std::string obj1SenderId;
            qDebug() << "test 2  SenderId";
            if (obj1["SenderId"].is_number()) {
                obj1SenderId = std::to_string(obj1["SenderId"].get<int>());
            } else if (obj1["SenderId"].is_string()) {
                obj1SenderId = obj1["SenderId"].get<std::string>();
            } else {
                qDebug() << "SenderId is neither number nor string";
            }
            qDebug() << "test 2  ReceiverId ";
            std::string obj1ReceiverId;
            if (obj1["ReceiverId"].is_number()) {
                obj1ReceiverId = std::to_string(obj1["ReceiverId"].get<int>());
            } else if (obj1["ReceiverId"].is_string()) {
                obj1ReceiverId = obj1["ReceiverId"].get<std::string>();
            } else {
                qDebug() << "ReceiverId is neither number nor string";
            }
            if (((objSenderId == obj1SenderId) && (obj1ReceiverId == objReceiverId))
                || ((objSenderId == obj1ReceiverId) && (obj1SenderId == objReceiverId))) {
                break;
            }
            count = count + 1;
            messages.remove(count);
        }
        std::string temp = newMessage.dump();
        messages.push_back(QString::fromStdString(temp));
    }
}

//初始化消息预览列表的第一条消息
void MessagePreviewPageController::getFirstInfos()
{
    this->messages = FileTools::getInstance()->getFirstInfos();
}

QString MessagePreviewPageController::getMessage()
{
    return message;
}

void MessagePreviewPageController::setMessage(QString message)
{
    this->message = message;
    std::cout << message.toStdString();
    emit messageChanged();
}

void MessagePreviewPageController::initMessagePreviewPage()
{
    qDebug() << "开始初始化消息预览界面";
    messages = FileTools::getInstance()->getFirstInfos();
    for (QString value : messages) {
        qDebug() << value;
        this->message = value;
        qDebug() << "添加消息到消息预览界面";
        emit messageChanged();
    }
}
