#include "addfriendpagecontroller.h"
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <nlohmann/json.hpp>

using nlohmann::json;

void AddFriendPageController::SetFriendRequestInfo() const {}

void AddFriendPageController::setFriendDetail() const {}

void AddFriendPageController::setAddFri(int addfri)
{
    m_addfri = addfri;
};

int AddFriendPageController::addFri() const
{
    return m_addfri;
};

void AddFriendPageController::receiveFriBaseInfo(char *text)
{
    emit friendBaseInfo(QString::fromStdString(json::parse(text).dump()));
}

QString AddFriendPageController::onSearchTextChanged(QString text)
{
    qDebug() << text.toStdString();

    // 1. send get friend info request to server
    json str;
    str.push_back({"request", "getFriendBaseInfo"});
    str.push_back({"na", "friendBaseinfo"});
    if (str[0][1] == "getFriendBaseInfo") {
        emit friendBaseInfo(QString::fromStdString(str.dump()));
    }

    return text;
}

bool AddFriendPageController::onSendAddFriRequest(int target_id)
{
    qDebug() << target_id;

    //1. send friend request to server

    return true;
}

void AddFriendPageController::receiveAddRequest(char *text)
{
    emit sendToAddFriRequest(QString::fromStdString(json::parse(text).dump()));
}

void AddFriendPageController::onAddToContacts(int ID,
                                              QString nickname,
                                              QString firstletter,
                                              QString avatar_path)
{
    // 1.add to m_friendlist
    // 2.store in local document
    // 3.send accept signal to server(with accepter id) 所有查找过的其他人的基本信息都存在一个文件里面， 该文件有状态friend_state: 1 -1,代表是否是朋友关系
}

void AddFriendPageController::receiveAcceptSignal(char *text)
{
    emit sendAcceptSignal(text);
}

/* server: send msg 
 * -> client: receive string 
 * -> client: string to json to QString
 * -> ensure request type 
 * -> call related function(send signal to qml, (QString)json msg as para of signal)
 * -> qml received json msg 
 * -> qml set value by json msg 
 * -> qml update ui 
*/
