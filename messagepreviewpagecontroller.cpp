#include "messagepreviewpagecontroller.h"

#include "client.h"

#include <iostream>
MessagePreviewPageController::MessagePreviewPageController(QObject *parent) {}
void MessagePreviewPageController::handelOfflineMessage()
{
    std::cout << "请求服务端推送离线消息" << std::endl;
    //nlohmann::json request = {{"id", ID}, {"request", "GetOfflineMessage"}};
    //std::string requestData=request.dump();
    //客户端连接、客户端请求、客户端接受
    std::cout << "客户端获取服务端发送的消息" << std::endl;
    //处理消息-》判断是json，type，接收保存到本地指定路径-》给message赋值
    //发出信号，qml接受到并显示
    // emit messagesChanged();
    // std::cout << "发送messageChanged（）信号" << std::endl;
    emit messagesReceiver();
}

void MessagePreviewPageController::receiveOfflineMessage(nlohmann::json jsonMessage)
{
    //测试表示服务端向客户端发送离线消息
    this->jsonMessage = jsonMessage;
    handelOfflineMessage();
}

QString MessagePreviewPageController::getMessages() const
{
    return messages;
}

void MessagePreviewPageController::setMessages(QString message)
{
    messages = message;
    std::cout << messages.toStdString();
    emit messagesChanged(messages);
}

int MessagePreviewPageController::getPersonCount() const
{
    return personCount;
}

void MessagePreviewPageController::setPersonCount(int count)
{
    personCount = count;
}
