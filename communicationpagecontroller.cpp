#include "communicationpagecontroller.h"
#include <QDateTime>
#include "client.h"
#include "filetools.h"
#include <string>
CommunicationPageController *CommunicationPageController::communicationPageController;

CommunicationPageController *CommunicationPageController::getInstance()
{
    if (communicationPageController == nullptr) {
        communicationPageController = new CommunicationPageController();
    }
    return communicationPageController;
}
void CommunicationPageController::initCommunicationPage()
{
    getCommunicationInfos();
    for (QString &value : communicationMessages) {
        std::string str = value.toStdString();
        nlohmann::json jObject = nlohmann::json::parse(str);
        qDebug() << jObject.dump();

        std::string temp;
        qDebug() << "test 2";
        if (jObject["SenderId"].is_number()) {
            temp = std::to_string(jObject["SenderId"].get<int>());
        } else if (jObject["SenderId"].is_string()) {
            temp = jObject["SenderId"].get<std::string>();
        } else {
            qDebug() << "SenderId is neither number nor string";
        }

        if (QString::fromStdString(temp) != senderId) {
            qDebug() << getSenderId();
            qDebug() << "setReceiverMessage";
            setReceiverMessage(value);
            emit receiverMessageChanged();
        } else {
            qDebug() << "setSenderMessage";
            setSenderMessage(value);
            qDebug() << value;
            emit senderMessageChanged();
        }
    }
}

void CommunicationPageController::getCommunicationInfos()
{
    this->communicationMessages = FileTools::getInstance()->getCommunciationInfos(getReceiverId(),
                                                                                  getSenderId());
}

void CommunicationPageController::getOnlineMessage(nlohmann::json newMessage)
{
    //判断是否是当前聊天页面的receiverid

    std::string senderId = newMessage.at("ReceiverId");
    qDebug() << getSenderId() << "_" << QString::fromStdString(newMessage.at("ReceiverId"));
    qDebug() << " CommunicationPageController::getOnlineMessage";
    if (QString::fromStdString(senderId) == getSenderId()) {
        receiverMessage = QString::fromStdString(newMessage.dump());
        emit receiverMessageChanged();
        qDebug() << " CommunicationPageController::getOnlineMessagereceiverMessageChanged";
    } else {
        qDebug() << "!!1! CommunicationPageController::getOnlineMessagereceiverMessageChanged";
    }
}

void CommunicationPageController::saveMessage()
{
    //senderMessage已经变化发
    //  Client::getInstance()->send();
}
//针对文本
void CommunicationPageController::sendNewMessage()
{
    QString MessageContent = getNewSendMessage();
    nlohmann::json request;
    request["MessageContent"] = MessageContent.toStdString();
    request["MessageType"] = "Text";
    request["ReceiverId"] = getReceiverId().toStdString();
    request["SenderId"] = getSenderId().toStdString();
    QDateTime currentDateTime = QDateTime::currentDateTime();
    request["SendTime"] = currentDateTime.toString("yyyy-MM-dd hh:mm:ss").toStdString();
    request["request_type"] = "SendMessage";

    std::string str = request.dump();
    char *json_buf = new char[1024];
    strcpy(json_buf, str.data());
    Client::getInstance()->send(json_buf, strlen(json_buf));

    qDebug() << request.dump();
    delete[] json_buf;
    QString filename = getReceiverId() + getSenderId();

    FileTools::getInstance()->saveMessageText(request, filename);

    setSenderMessage(QString::fromStdString(request.dump()));
    //类型转换过去没办法赋值
    emit senderMessageChanged();
}
