#ifndef MESSAGEPREVIEWPAGECONTROLLER_H
#define MESSAGEPREVIEWPAGECONTROLLER_H
#include <QMap>
#include <QObject>
#include <iostream>
#include <nlohmann/json.hpp>
/*
 * 1.用户启动客户端就会发送一个请求、接收离线消息（MessagePreviewPageController）getOfflineMessage获取所有离线消息，并给页面初始化
 * 2.所有的离线消息会保存在客户端，用户点击相应的聊天用户就会跳转读取相应的信息
 * 
 */
class MessagePreviewPageController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString message READ getMessage WRITE setMessage NOTIFY messageChanged)
    Q_PROPERTY(QString myId READ getMyId WRITE setMyId NOTIFY myIdChanged)

public:
    static MessagePreviewPageController *getInstance();
    MessagePreviewPageController(QObject *parent = nullptr);
    Q_INVOKABLE void getOfflineMessage();
    //-----------
    Q_INVOKABLE void getUsersAvatar();
    Q_INVOKABLE void getFriendInfo();
    //-----------
    void getOnlineMessage(nlohmann::json newMessage);
    Q_INVOKABLE void getFirstInfos();

    Q_INVOKABLE void initMessagePreviewPage();
    Q_INVOKABLE QString getMessage();
    Q_INVOKABLE void setMessage(QString message);

    Q_INVOKABLE QString getMyId() { return myId; }
    Q_INVOKABLE void setMyId(QString str) { myId = str; };

signals:
    void messageChanged();
    void messagesReceiver();
    void myIdChanged();

    void newOnlineMessage();
public slots:
    void onMessagesReceived() { std::cout << "get message form aml" << std::endl; };

private:
    //test
    QString message;
    QString myId;
    nlohmann::json jsonMessage;
    QVector<QString> messages;
    static MessagePreviewPageController *messagePreviewPageController;
};

#endif
