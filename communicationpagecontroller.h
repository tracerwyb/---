#ifndef COMMUNICATIONPAGECONTROLLER_H
#define COMMUNICATIONPAGECONTROLLER_H
#include <QObject>
#include <nlohmann/json.hpp>
//判断用户（ID）聊天对象是否在线，在线直接发消息，不在线发送给服务器存储；调用client的功能向对面发送消息；接收别人发送的消息
class CommunicationPageController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString receiverMessage READ getReceiverMessage WRITE setReceiverMessage NOTIFY
                   receiverMessageChanged)
    Q_PROPERTY(QString senderMessage READ getSenderMessage WRITE setSenderMessage NOTIFY
                   senderMessageChanged)
    // Q_PROPERTY(std::string newSendMessage READ getNewSendMessage WRITE setNewSendMessage NOTIFY
    //                newSendMessageChanged)
    Q_PROPERTY(QString newSendMessage READ getNewSendMessage WRITE setNewSendMessage NOTIFY
                   newSendMessageChanged)
    Q_PROPERTY(QString receiverId READ getReceiverId WRITE setReceiverId NOTIFY receiverIdChanged)
    Q_PROPERTY(QString senderId READ getSenderId WRITE setSenderId NOTIFY senderIdChanged)
    //offline->online;
public:
    static CommunicationPageController *getInstance();
    Q_INVOKABLE void initCommunicationPage();
    void getCommunicationInfos();
    void getOnlineMessage(nlohmann::json newMessage);

    // void receiverNewReceivMessage();
    Q_INVOKABLE void saveMessage();
    Q_INVOKABLE void sendNewMessage();

    Q_INVOKABLE QString getReceiverMessage() { return receiverMessage; };
    Q_INVOKABLE void setReceiverMessage(QString str) { receiverMessage = str; }

    Q_INVOKABLE QString getSenderMessage() { return senderMessage; };
    Q_INVOKABLE void setSenderMessage(QString str) { senderMessage = str; }

    Q_INVOKABLE QString getReceiverId() { return receiverId; };
    Q_INVOKABLE void setReceiverId(QString i) { receiverId = i; }

    // Q_INVOKABLE std::string getNewSendMessage() { return newSendMessage; };
    // Q_INVOKABLE void setNewSendMessage(std::string i) { newSendMessage = i; }

    Q_INVOKABLE QString getNewSendMessage() { return newSendMessage; };
    Q_INVOKABLE void setNewSendMessage(QString i) { newSendMessage = i; }

    Q_INVOKABLE QString getSenderId() { return senderId; }
    Q_INVOKABLE void setSenderId(QString i) { senderId = i; }

signals:
    //qml调用、c++处理
    void senderMessageChanged();
    //c++调用、qml处理
    void receiverMessageChanged();

    void newSendMessageChanged();

    void receiverIdChanged();
    void senderIdChanged();

public slots:

private:
    QVector<QString> communicationMessages;
    QString receiverMessage;
    QString senderMessage;
    QString senderId;
    QString receiverId;
    QString newSendMessage;
    static CommunicationPageController *communicationPageController;
};

#endif
