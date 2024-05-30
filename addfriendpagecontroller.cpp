#include "addfriendpagecontroller.h"
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <nlohmann/json.hpp>

using nlohmann::json;

void AddFriendPageController::SetFriendRequestInfo() const {}

void AddFriendPageController::setFriendDetail() const {}

void AddFriendPageController::setMUserID(int user_id)
{
    m_userid = user_id;
}

void AddFriendPageController::receiveFriBaseInfo(char *text)
{
    emit friendBaseInfo(QString::fromStdString(json::parse(text).dump()));
}

QString AddFriendPageController::onSearchTextChanged(QString text)
{
    qDebug() << text.toStdString();

    //send get friend info request to server
    json getfrinfo;
    getfrinfo.push_back({"request_type", "getfribaseinfo"});
    getfrinfo.push_back({"friendID", text.toStdString()});
    // str.push_back({"ID", "20000000"});

    Client::getInstance()->send(getfrinfo.dump().data(), sizeof(getfrinfo.dump().data()));

    return text;
}

bool AddFriendPageController::onSendAddFriRequest(int target_id)
{
    qDebug() << target_id;

    //1. get my info from local document
    json addfrireq;
    addfrireq["request_type"] = "addfriend";
    addfrireq["target_id"] = target_id;
    addfrireq["my_id"] = "20209834";
    addfrireq["my_nickname"] = "85";
    addfrireq["my_avatar"] = "../assets/Picture/avatar/cat.png";
    addfrireq["who"] = "8.5";
    addfrireq["gender"] = "女";
    addfrireq["area"] = "中国 重庆";
    addfrireq["signature"] = "罪恶没有假期，正义便无暇休憩";

    //2. send friend request to server
    Client::getInstance()->send(addfrireq.dump().data(), sizeof(addfrireq.dump().data()));

    return true;
}

void AddFriendPageController::receiveAddRequest(char *text)
{
    emit sendToAddFriRequest(QString::fromStdString(json::parse(text).dump()));
}

void AddFriendPageController::onAddToContacts(int ID,
                                              QString nickname,
                                              QString avatar_path,
                                              QString gender,
                                              QString area,
                                              QString signal_text,
                                              QString memo)
{
    // 1.add to m_friendlist
    json friendinfo;
    friendinfo["relation"] = "friend";
    friendinfo["ID"] = ID;
    friendinfo["nickname"] = nickname.toStdString();
    friendinfo["avatar_path"] = avatar_path.toStdString();
    friendinfo["gender"] = gender.toStdString();
    friendinfo["area"] = area.toStdString();
    friendinfo["signal_text"] = signal_text.toStdString();
    friendinfo["memo"] = memo.toStdString();

    m_friendlist.push_back(friendinfo);

    // 2.store in local document

    // 3.send accept signal to server(with accepter id) 所有查找过的其他人的基本信息都存在一个文件里面
    json acceptinfo;
    acceptinfo["request_type"] = "acceptfrinfo";
    acceptinfo["acceptor_id"] = m_userid;
    acceptinfo["requestsender_id"] = ID;

    Client::getInstance()->send(acceptinfo.dump().data(), sizeof(acceptinfo.dump().data()));
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
