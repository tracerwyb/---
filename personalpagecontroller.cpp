#include "personalpagecontroller.h"
#include "client.h"
#include "nlohmann/json.hpp"
#include <QString>


QString PersonalPageController::m_acceptmsg=NULL;
PersonalPageController *PersonalPageController::ppc = nullptr;

PersonalPageController::PersonalPageController(QObject *parent)
    : QObject{parent}
{
    ppc=this;
}

void PersonalPageController::setNetname(const QString str)
{
    m_name = str;
    qDebug()<<"m_name:"<<m_name;
    emit netnameChanged(str);
}

QString PersonalPageController::netname() const
{
    return m_name;
}

void PersonalPageController::setNetnumber(const QString number)
{
    m_number=number.toInt();
    qDebug()<<"m_number:"<<m_number;
    emit netnumberChanged(m_number);
}

QString PersonalPageController::netnumber() const
{
    return QString::number(m_number);
}

void PersonalPageController::setAcceptid(const QString number)
{
    m_acceptid=number.toInt();
    qDebug()<<"m_acceptid:"<<m_acceptid;
    emit acceptidChanged(m_number);
}

QString PersonalPageController::acceptid() const
{
    return QString::number(m_acceptid);
}

QString PersonalPageController::acceptmsg()
{
    return PersonalPageController::m_acceptmsg;
}

void PersonalPageController::setSendmsg(const QString sendmsg)
{
    m_sendmsg=sendmsg;
    emit sendmsgChanged(sendmsg);
}

void PersonalPageController::setAcceptmsg(std::string acmsg)
{
    PersonalPageController::m_acceptmsg=QString::fromStdString(acmsg);
    qDebug()<<"setAceeptmsg succeed"<<m_acceptmsg;
    emit ppc->acceptmsgChanged(m_acceptmsg);
}

void PersonalPageController::initPersonalData()
{
    nlohmann::json j;
    j["myid"]="3326336521";
    j["myname"]="坐看云起时";
    std::string personaldata=j.dump();
    auto jsonObject=nlohmann::json::parse(personaldata);
    // m_number = QString::fromStdString(jsonObject.at("myid"));
    m_name = QString::fromStdString(jsonObject.at("myname"));
}

void PersonalPageController::test()
{
    Client *client=Client::getInstance();      //点击登陆时创建Client实例，调用start（）方法与服务器建立连接
    client->start();
                       //如果我在这里开启接受消息的监听线程，那这个函数执行完监听线程会中断，如果在这里等待监听线程返回，再执行下面的语句，那会不会影响前端调用这个函数的线程阻塞导致前端显示异常呢,还是说前端有前端自己的线程，各个组件都是异步加载的，这个函数没有结束并没有什么影响
}

void PersonalPageController::send()
{
    Client *client=Client::getInstance();      //
    client->setId(m_number);
    client->setAcceptId(m_acceptid);
    client->setRequestType();
    char* buf=client->Messagedata(m_sendmsg);
    char* json_buf=new char[1024];
    client->comversionJson(json_buf);
    qDebug()<<"send front";
    client->send(json_buf,strlen(json_buf));    //点击发送按钮后,调用send方法发送已经序列化的json字符串
    qDebug()<<"send back";
    delete[] json_buf;
}

void PersonalPageController::inite()
{
    nlohmann::json j;
    j["request_type"]="initPersonalPage";
    std::string s=j.dump();
    Client::getInstance()->send(s.data(),strlen(s.data()));
    qDebug()<<"inite was excute!";
}

void PersonalPageController::sendImage(){
    nlohmann::json j;
    j["request_type"]="sendimage";
    j["acceptid"]=1;
    // j["acceptid"]=2;
    std::string s=j.dump();
    Client::getInstance()->send(s.data(),strlen(s.data()));
    Client::getInstance()->sendImage("/run/media/root/study/avater2.jpg");
    qDebug()<<"sendimage was excute!";
}

