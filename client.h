#ifndef CLIENT_H
#define CLIENT_H
#include <iostream>
#include <QDateTime>
#define MAX 1024
class Client
{
public:
    Client();
    char* Messagedata();
    void comversionJson(char* json_buf);
    void setId();
    void setAcceptId();
    void setRequestType();
private:
    int id;
    int acid;
    std::string request_type;
    QDateTime time;
    char buf[MAX];
};

#endif // CLIENT_H
