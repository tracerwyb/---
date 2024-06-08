

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
#include "client.h"
#include <nlohmann/json.hpp>

using nlohmann::json;

class AddFriendPageController : public QObject
{
    Q_OBJECT

public:
    Q_INVOKABLE void setMUserID(int user_id);
    Q_INVOKABLE void SetFriendRequestInfo() const;
    Q_INVOKABLE void setFriendDetail() const;
//----
    static void receiveFriBaseInfo(char *text);
    static void isFriend(char *text);
    AddFriendPageController(QObject *parent = nullptr);
//----
    static void receiveAddRequest(char *text); // receive friends' all base info, request type: "addFriendRequest"
    static void receiveAcceptSignal(char *text);
    Q_INVOKABLE void initFriendReqs();
    Q_INVOKABLE void initFriendList();
    Q_INVOKABLE void onAddToContacts(QString ID,
                                     QString nickname,
                                     QString avatar_path,
                                     QString gender,
                                     QString area,
                                     QString signal_text,
                                     QString memo);
signals:
    void friendBaseInfo(QString);
    void sendAcceptSignal(QString);
    void isFriendSignal(QString);
    void initfrilist(QString);
    void initFriReq(QString);

public slots:
    QString onSearchTextChanged(QString text);
    bool onSendAddFriRequest(int target_id); // send user id and target(friend) id to server

    void onContactListClicked();
    void onSaveToLocal(QString, QString);

private:
    int m_userid; // initialize when user login
    static AddFriendPageController *adfc;
    std::vector<json> m_friendlist;
};

#endif
