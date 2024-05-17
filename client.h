#ifndef CLIENT_H
#define CLIENT_H

#include <string>

#define MAX 50

class Network;
class Client
{
private:
    static Client *m_instance;
    Network *m_network;
    char buf[MAX];
        
public:
    char *Messagedata();

    static Client *getInstance();

    void send(const char *buf, size_t size);

    bool receive(char *buf);

    void start();

    void reconnect();

    std::string receiveFile();

    void closeSocket();
};

#endif
