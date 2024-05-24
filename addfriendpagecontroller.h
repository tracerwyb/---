

// add friend flow

/* 1. input friend id   -------------------------------------------------------------------------------finished
 * 2. send friend id to server   ----------------------------------------------------------------------finished
 * 3. server return friend base info as a filter
 * 4. show friend base info and add interface 
 * 5. user choose to add friend or reset to last page (pretend to choose add)
 * 6. user press add button
 * 7. client send a request named "addFriendRequest" to server with id and friend_id(already got)
 * 8. server send request to target user
 * 9. target user client show request(name,avatar,add_reason) 
 * 10. target user choose accept or refuse request
 * 11. update friend list(contacts list page)  --------------------------------------------------------finished
 * 12. send choice to server with id
 * 13. user: reveive result and update friend list(accept)
*/

#ifndef ADDFRIENDPAGECONTROLLER_H
#define ADDFRIENDPAGECONTROLLER_H

#include <QObject>
#include <QString>

#include <QJsonDocument>
#include <QJsonObject>
class AddFriendPageController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int addFri READ addFri WRITE setAddFri NOTIFY addFriChanged FINAL)

public:
    Q_INVOKABLE void SetFriendRequestInfo() const;
    Q_INVOKABLE void setFriendDetail() const;

    Q_INVOKABLE int addFri() const;
    Q_INVOKABLE void setAddFri(int);
    Q_INVOKABLE QString jsonToQstring(QJsonObject jsonObject);
    Q_INVOKABLE QJsonObject qstringToJson(QString jsonString);

signals:
    void addFriChanged(QString friend_name, QString first_letter, QString avatar_path);
    void friendBaseInfo(QString);

public slots:
    QString onSearchTextChanged(QString text);

private:
    int m_addfri = 0;
};

#endif
