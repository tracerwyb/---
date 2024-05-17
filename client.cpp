#include "client.h"
#include "string.h"
#include <iostream>

Client *Client::getInstance() {}

void Client::send(const char *buf, size_t size) {}

bool Client::receive(char *buf) {}

void Client::start() {}

void Client::reconnect() {}

std::string Client::receiveFile() {}

void Client::closeSocket() {}

char* Client::Messagedata()
{
    std::cout<<"please enter your message:"<<std::endl;
    std::cin>>buf;
    return buf;
}
