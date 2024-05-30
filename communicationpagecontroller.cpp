#include "communicationpagecontroller.h"

void CommunicationPageController::saveMessage()
{
    //在线接发消息的保存
}

void CommunicationPageController::sendMessage()
{
    //Client单例模式调用start、connect连接用户{自己没网络(连接用户前先连接一个公共网址测试)}
    //sender-true,receiver-true -》receiver
    //sender-true；receiver-false -》serve
    //sender-false；-》“！发送失败”
}

void CommunicationPageController::getMessageOnline()
{
    //Client-receiver-》有新的消息出现就处理消息-》receiverMessageChange-》发送信号-》qml处理
}

void CommunicationPageController::getSenderUserState()
{
    //连接服务器
}

void CommunicationPageController::getReceiverUserState()
{
    //连接receiver
}
