#ifndef NETWORK_H
#define NETWORK_H

class Network
{
public:
    int m_listenfd;
    Network();
    void createSocket();
    void sendTextMessage(char* sendmessage,int size);
    void reciveTextMessage();
    void closeSocket();
    int Select();
private:
    //int m_listenfd;

};

#endif // NETWORK_H
