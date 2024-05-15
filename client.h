#ifndef CLIENT_H
#define CLIENT_H
#include <iostream>
#define MAX 1024
class Client
{
public:
    Client();
    char *Messagedata();


private:
        char buf[MAX];
};

#endif // CLIENT_H
