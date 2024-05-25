#ifndef COMMUNICATIONPAGECONTROLLER_H
#define COMMUNICATIONPAGECONTROLLER_H
#include <QObject>
//判断用户（ID）聊天对象是否在线，在线直接发消息，不在线发送给服务器存储；调用client的功能向对面发送消息；接收别人发送的消息
class CommunicationPageController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString receiverMessage READ getReceiverMessage WRITE setReceiverMessage NOTIFY
                   receiverMessageChanged)
    Q_PROPERTY(QString senderMessage READ getSenderMessage WRITE setSenderMessage NOTIFY
                   senderMessageChanged)
    Q_PROPERTY(bool senderState READ getSenderState WRITE setSenderState NOTIFY senderStateChanged)

    Q_PROPERTY(
        bool receiverState READ getReceiverState WRITE setReceiverState NOTIFY receiverStateChanged)
    //offline->online;
public:
    QString getReceiverMessage() { return receiverMessage; };
    void setReceiverMessage(QString str) { receiverMessage = str; }

    QString getSenderMessage() { return senderMessage; };
    void setSenderMessage(QString str) { receiverMessage = str; }

    bool getSenderState() { return senderState; };
    void setSenderState(bool str) { senderState = str; }

    bool getReceiverState() { return receiverState; };
    void setReceiverState(bool str) { receiverState = str; }

signals:
    //qml调用、c++处理
    void senderMessageChanged();
    //c++调用、qml处理
    void receiverMessageChanged();
    void senderStateChanged();
    void receiverStateChanged();
public slots:
    //  void onSenderMessageChange();
    //  void onReceiverMessageChanged();
    //  void onSenderStateChanged();
    //  void onReceiverStateChanged();

public:
    void sendMessage();
    void getMessageOnline();
    //判断sender网络
    void getSenderUserState();

    //连接套接字、判断receiver网络
    void getReceiverUserState();

private:
    QString receiverMessage;
    QString senderMessage;
    bool senderState;
    bool receiverState;
};

#endif
