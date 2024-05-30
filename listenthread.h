#ifndef LISTENTHREAD_H
#define LISTENTHREAD_H

#include "addfriendpagecontroller.h"

#include <QThread>
class ListenThread:public QThread
{
    Q_OBJECT
public:
    ListenThread(QObject *parent=nullptr);
signals:
    void finish();
public slots:
    void startThread();
    void stopThread();
protected:
    void run()override;
    bool state;
    AddFriendPageController *m_afc;
};

#endif // LISTENTHREAD_H
