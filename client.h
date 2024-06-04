#ifndef CLIENT_H
#define CLIENT_H
#include "network.h"
#include <string>
#include <iostream>
#include <QDateTime>
#include <QQmlEngine>
#define MAX 1024

class Client
{

private:
    Client();
    static Client* m_instance;

    Network m_network;

    char buf[MAX];
    int id;
    int acid;
    std::string request_type;
    QDateTime time;

    QString m_name;

signals:
    void  netnameChanged(const QString netname);
public:
    static Client *getInstance();

    void send(char *buf, int size);

    int receive(char *buf);

    QPixmap receiveImage();
    void sendImage(std::string path);

    void start();

    int select();

    //void reconnect();

    //std::string receiveFile();

    void closeSocket();

    
    char *Messagedata(QString string);
    void comversionJson(char* json_buf);
    void setId(int);
    void setAcceptId(int);
    int getId();
    void setRequestType();

};

#endif
