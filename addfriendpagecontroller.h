#ifndef ADDFRIENDPAGECONTROLLER_H
#define ADDFRIENDPAGECONTROLLER_H

#include <QObject>

class AddFriendPageController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int add_fri WRITE setAddfri NOTIFY addFriend)

public:
	void SetFriendRequestInfo();
	void setFriendDetail();

    // int getAddfri();
    void setAddfri(int) { emit addFriend(2001241, "path"); };

signals:
    void addFriend(int friend_id, QString friend_avatar);
};

#endif
