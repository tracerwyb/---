#include "client.h"
#include "string.h"
#include "nlohmann/json.hpp"
#include <iostream>
#include <QString>
Client::Client(int id):id{id} {
    time = QDateTime::currentDateTime();
    qDebug()<<time.toString();
}

char* Client::Messagedata()
{
    std::cout<<"please enter your message:"<<std::endl;
    std::cin.get(buf,1024);
    return buf;
}

void Client::comversionJson(char* json_buf)
{
    nlohmann::json j;
    j["id"]=id;
    QString date=time.toString();
    std::string dt=date.toStdString();
    j["date"]=dt;
    j["content"]=buf;
    std::string s=j.dump();
    strcpy(json_buf,s.data());
}
