#include "client.h"
#include "string.h"
#include <iostream>
Client::Client() {}

char* Client::Messagedata()
{
    std::cout<<"please enter your message:"<<std::endl;
    std::cin>>buf;
    return buf;
}
