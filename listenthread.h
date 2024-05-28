#ifndef LISTENTHREAD_H
#define LISTENTHREAD_H

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
};

#endif // LISTENTHREAD_H
