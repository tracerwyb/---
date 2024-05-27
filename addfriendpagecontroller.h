

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
    void receiveFriBaseInfo(char *text);
    void receiveAddRequest(
        char *text); // receive all friend base info, request type: "addFriendRequest"
    void receiveAcceptSignal(char *text);
    // Q_INVOKABLE QString jsonToQstring(QJsonObject jsonObject);
    // Q_INVOKABLE QJsonObject qstringToJson(QString jsonString);

signals:
    void friendBaseInfo(QString);
    void sendToAddFriRequest(QString);
    void sendAcceptSignal(char *text);

public slots:
    QString onSearchTextChanged(QString text);
    bool onSendAddFriRequest(int target_id); // send user id and target(friend) id to server
    void onAddToContacts(int ID, QString nickname, QString firstletter, QString avatar_path);

private:
    int m_addfri = 0;
    int user_id; // initialize when user login
    std::vector<int> m_friendlist;
};

#endif
