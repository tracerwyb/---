 #include "client.h"
#include "string.h"
#include "nlohmann/json.hpp"
#include <iostream>
#include <string>

Client::Client(){
    qDebug()<<"Client connect Server......";
}
Client* Client::m_instance = nullptr;
Client *Client::getInstance() {
    if (m_instance == nullptr) {
        m_instance=new Client();
        qDebug() << "client getinstance-------------";
    }
    return m_instance;
}

void Client::send(char *buf, int size) {
    m_network.sendTextMessage(buf, size);
}

int Client::receive(char *buf) {
    int n=m_network.reciveTextMessage(buf);
    return n;
}

QPixmap Client::receiveImage()
{
    QPixmap tempQPixmap;
    return m_network.recImage();
}

void Client::sendImage(std::string path)
{
    m_network.sendImage(path);
}

void Client::start() {

    m_network.createSocket();
    qDebug() << "create socket-------------";
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


char* Client::Messagedata(QString sendmsg)
{
    // std::cout<<"please enter your message:"<<std::endl;
    // std::cin.get(buf,1024);
   // std::string s={"hello good morning"};

    std::string s=sendmsg.toStdString();
    strcpy(buf,s.c_str());
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
void Client::setId(int inputid)
{
    time = QDateTime::currentDateTime();
    // std::cout<<"Please input your id:"<<std::endl;
    // std::cin>>id;
    // std::cin.get();
    id=inputid;
}


void Client::setAcceptId(int id){
    // std::cout<<"Please input aceept id:"<<std::endl;
    // std::cin>>acid;
    // std::cin.get();
    acid=id;
}
int Client::getId()
{
    return id;
}

void Client::setRequestType(){
    // std::cout<<"Please requst type:"<<std::endl;
    // std::cin>>request_type;
    // std::cin.get();
    request_type="sendmsg";
}
// void Client::setId()
// {
//     time = QDateTime::currentDateTime();
//     // std::cout<<"Please input your id:"<<std::endl;
//     // std::cin>>id;
//     // std::cin.get();
//     id=5;
// }

// void Client::setAcceptId(){
//     // std::cout<<"Please input aceept id:"<<std::endl;
//     // std::cin>>acid;
//     // std::cin.get();
//     acid=3;
// }
// void Client::setRequestType(){
//     // std::cout<<"Please requst type:"<<std::endl;
//     // std::cin>>request_type;
//     // std::cin.get();
//     request_type="sendmsg";
// }

