#ifndef MESSAGEPREVIEWPAGECONTROLLER_H
#define MESSAGEPREVIEWPAGECONTROLLER_H
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
    Q_PROPERTY(QString messages READ getMessages WRITE setMessages NOTIFY messagesChanged FINAL)
    Q_PROPERTY(int personCount READ getPersonCount WRITE setPersonCount)
public:
    MessagePreviewPageController(QObject *parent = nullptr);
    Q_INVOKABLE void handelOfflineMessage();

    //test
    void receiveOfflineMessage(nlohmann::json jsonMessage);

    Q_INVOKABLE QString getMessages() const;
    Q_INVOKABLE void setMessages(QString message);

    Q_INVOKABLE int getPersonCount() const;
    Q_INVOKABLE void setPersonCount(int count);
signals:
    Q_INVOKABLE void messagesChanged(QString message);
    Q_INVOKABLE void messagesReceiver();
public slots:
    void onMessagesReceived() { std::cout << "get message form aml" << std::endl; };

private:
    //test
    QString messages;
    nlohmann::json jsonMessage;
    int personCount = 0;
};

#endif
