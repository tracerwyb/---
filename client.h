#ifndef CLIENT_H
#define CLIENT_H
#include <iostream>
#include <QDateTime>
#define MAX 1024
class Client
{
public:
    Client(int id);
    char* Messagedata();
    void comversionJson(char* json_buf);

private:
    int id;
    QDateTime time;
    char buf[MAX];
};

#endif // CLIENT_H
