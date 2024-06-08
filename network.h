#ifndef NETWORK_H
#define NETWORK_H
#include <QPixmap>
class Network
{
public:
    int m_listenfd;
    Network();
    void createSocket();

    void sendTextMessage(char* sendmessage,int size);
    int reciveTextMessage(char *recivemessage);

    QPixmap recImage();    //待修改
    void sendImage(std::string path);

    void closeSocket();
    int Select();
private:
    //int m_listenfd;

};

#endif // NETWORK_H
