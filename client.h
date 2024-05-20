#ifndef CLIENT_H
#define CLIENT_H
#include <string>
#include <iostream>
#include <QDateTime>
#define MAX 1024

class Client
{
private:
    static Client *m_instance;
    Network *m_network;
    char buf[MAX];
    int id;
    int acid;
    std::string request_type;
    QDateTime time;
    int acid;
    std::string request_type;
        
public:
    static Client *getInstance();

    void send(const char *buf, size_t size);

    bool receive(char *buf);

    void start();

    void reconnect();

    std::string receiveFile();

    void closeSocket();

    
    char *Messagedata();
    void comversionJson(char* json_buf);
    void setId();
    void setAcceptId();
    void setRequestType();
    
};

#endif
