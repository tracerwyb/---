#include "client.h"
#include "string.h"
#include "nlohmann/json.hpp"
#include <iostream>

Client::Client(){
    m_network.createSocket();
    qDebug()<<"Client connect Server......";
}
Client* Client::m_instance = nullptr;
Client *Client::getInstance() {
    if(m_instance == nullptr){
        m_instance=new Client();
    }
    return m_instance;
}

void Client::send(char *buf, int size) {
    m_network.sendTextMessage(buf,size);
}

bool Client::receive(char *buf) {
    m_network.reciveTextMessage(buf);
    return NULL;
}

void Client::start() {

    m_network.createSocket();
}

int Client::select()
{
    int result=m_network.Select();
    return result;
}

//void Client::reconnect() {}

//std::string Client::receiveFile() {}

void Client::closeSocket() {
    m_network.closeSocket();
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
    j["myid"]=id;
    j["acceptid"]=acid;
    j["request_type"]=request_type;
    QString date=time.toString();
    std::string dt=date.toStdString();
    j["date"]=dt;
    j["content"]=buf;
    std::string s=j.dump();
    strcpy(json_buf,s.data());
}

void Client::setId()
{    
    time = QDateTime::currentDateTime();
    std::cout<<"Please input your id:"<<std::endl;
    std::cin>>id;
    std::cin.get();
}

int Client::getId()
{
    return id;
}

void Client::setAcceptId(){
    std::cout<<"Please input aceept id:"<<std::endl;
    std::cin>>acid;
    std::cin.get();
}
void Client::setRequestType(){
    std::cout<<"Please requst type:"<<std::endl;
    std::cin>>request_type;
    std::cin.get();
}

