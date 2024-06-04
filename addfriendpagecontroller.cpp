#include "addfriendpagecontroller.h"
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include "filetools.h"
#include <nlohmann/json.hpp>
#include <unistd.h>

using nlohmann::json;
AddFriendPageController *AddFriendPageController::adfc=nullptr;

AddFriendPageController::AddFriendPageController(QObject *parent):QObject{parent}{
    adfc=this;
}


void AddFriendPageController::SetFriendRequestInfo() const {}

void AddFriendPageController::setFriendDetail() const {}

void AddFriendPageController::isFriend(char *text)
{
    qDebug() << "isfriend text: " << text;

    emit adfc->isFriendSignal(text);
}

void AddFriendPageController::setMUserID(int user_id)
{
    m_userid = user_id;
}

void AddFriendPageController::receiveFriBaseInfo(char *text)
{
    //QString::fromStdString(json::parse(text).dump())
    emit adfc->friendBaseInfo(text);
    qDebug()<<"signal was send!!!!!!!!!!!!!!!!";
}

QString AddFriendPageController::onSearchTextChanged(QString text)
{
    qDebug() << text.toStdString();

    json isfriend;
    isfriend["myid"] = Client::getInstance()->getId();
    isfriend["request_type"] = "isfriend";
    isfriend["friendID"] = text.toInt();
    qDebug() << "isfriend.dump()" << isfriend.dump();
    Client::getInstance()->send(isfriend.dump().data(), strlen(isfriend.dump().data()));

    //send get friend info request to server
    json getfrinfo;
    getfrinfo["myid"] = Client::getInstance()->getId();
    getfrinfo["request_type"] = "getfribaseinfo";
    getfrinfo["friendID"] = text.toInt();
    // str.push_back({"ID", "20000000"});

    Client::getInstance()->send(getfrinfo.dump().data(), strlen(getfrinfo.dump().data()));

    return text;
}

bool AddFriendPageController::onSendAddFriRequest(int target_id)
{
    qDebug() << "onSendAddFriRequest called";

    qDebug() << target_id;

    //1. get my info from local document
    json addfrireq;
    addfrireq["request_type"] = "addfriend";
    addfrireq["target_id"] = target_id;
    addfrireq["myid"] = Client::getInstance()->getId();
    addfrireq["my_nickname"] = "85";
    addfrireq["my_avatar"] = "../assets/Picture/avatar/cat.png";
    addfrireq["who"] = "8.5";
    addfrireq["gender"] = "女";
    addfrireq["area"] = "中国 重庆";
    addfrireq["signature"] = "罪恶没有假期，正义便无暇休憩";

    //2. send friend request to server
    Client::getInstance()->send(addfrireq.dump().data(), strlen(addfrireq.dump().data()));

    return true;
}

void AddFriendPageController::receiveAddRequest(char *text)
{
    qDebug() << "receiveAddRequest called";
    FileTools::getInstance()->saveRequest(nlohmann::json::parse(text), "friend_request");
}

void AddFriendPageController::onAddToContacts(QString ID,
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
    friendinfo["ID"] = ID.toStdString();
    friendinfo["nickname"] = nickname.toStdString();
    friendinfo["avatar_path"] = avatar_path.toStdString();
    friendinfo["gender"] = gender.toStdString();
    friendinfo["area"] = area.toStdString();
    friendinfo["signal_text"] = signal_text.toStdString();
    friendinfo["memo"] = memo.toStdString();

    m_friendlist.push_back(friendinfo);

    // 2.store in local document
    FileTools::getInstance()->saveRequest(friendinfo, "relation");

    // 3.send accept signal to server(with accepter id) 所有查找过的其他人的基本信息都存在一个文件里面
    json acceptinfo;
    acceptinfo["request_type"] = "acceptfrinfo";
    acceptinfo["myid"] = Client::getInstance()->getId();
    acceptinfo["requestsender_id"] = ID.toStdString();

    Client::getInstance()->send(acceptinfo.dump().data(), strlen(acceptinfo.dump().data()));
}

void AddFriendPageController::receiveAcceptSignal(char *text)
{
    qDebug() << "receiveAcceptSignal:" << text;
    emit adfc->sendAcceptSignal(text);
}

void AddFriendPageController::initFriendReqs()
{
    auto reqs = FileTools::getInstance()->getReq("friend_request");
    for (QString &value : reqs) {
        qDebug() << "initFriendReqs value" << value;
        emit initFriReq(value);
    }
}

void AddFriendPageController::initFriendList()
{
    qDebug() << "init friend list";
    auto fris = FileTools::getInstance()->getReq("relation");
    for (QString &value : fris) {
        auto v = nlohmann::json::parse(value.toStdString());
        qDebug() << "friend list value" << value;
        if (v["relation"] == "friend") {
            qDebug() << "v['relation']";

            emit initfrilist(value);
        }
    }
}

void AddFriendPageController::onContactListClicked()
{
    qDebug() << "contact list page on clicked";
    initFriendList();
}

void AddFriendPageController::onSaveToLocal(QString content, QString file)
{
    FileTools::getInstance()->saveRequest(nlohmann::json::parse(content.toStdString()), file);
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
