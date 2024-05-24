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
    emit addFriChanged("saj", "s", "");
};

int AddFriendPageController::addFri() const
{
    return m_addfri;
};

QString AddFriendPageController::jsonToQstring(QJsonObject jsonObject)
{
    QJsonDocument document;
    document.setObject(jsonObject);
    QByteArray simpbyte_array = document.toJson(QJsonDocument::Compact);
    QString simpjson_str(simpbyte_array);

    return simpjson_str;
}
QJsonObject AddFriendPageController::qstringToJson(QString jsonString)
{
    QJsonDocument jsonDocument = QJsonDocument::fromJson(jsonString.toLocal8Bit().data());
    if (jsonDocument.isNull()) {
        qDebug() << "String NULL" << jsonString.toLocal8Bit().data();
    }
    QJsonObject jsonObject = jsonDocument.object();
    return jsonObject;
}

QString AddFriendPageController::onSearchTextChanged(QString text)
{
    qDebug() << text.toStdString();

    // send get friend info request to server
    json str;
    str.push_back({"request", "getFriendBaseInfo"});
    str.push_back({"na", "friendBaseinfo"});
    if (str[0][1] == "getFriendBaseInfo") {
        friendBaseInfo(QString::fromStdString(str.dump()));
    }
    return text;
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
