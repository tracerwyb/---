#include "personalpagecontroller.h"
#include "client.h"
#include "nlohmann/json.hpp"


PersonalPageController::PersonalPageController(QObject *parent)
    : QObject{parent}
{}

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
    m_number=number;
    qDebug()<<"m_number:"<<m_number;
    emit netnumberChanged(number);
}

QString PersonalPageController::netnumber() const
{
    return m_number;
}



void PersonalPageController::initPersonalData()
{
    nlohmann::json j;
    j["myid"]="3326336521";
    j["myname"]="坐看云起时";
    std::string personaldata=j.dump();
    auto jsonObject=nlohmann::json::parse(personaldata);
    m_number = QString::fromStdString(jsonObject.at("myid"));
    m_name = QString::fromStdString(jsonObject.at("myname"));
}

void PersonalPageController::test()
{
    Client *client=Client::getInstance();      //点击登陆时创建Client实例，调用start（）方法与服务器建立连接
    client->start();
    client->setId();
    client->setAcceptId();
    client->setRequestType();
    char* buf=client->Messagedata();
    char* json_buf=new char[1024];
    client->comversionJson(json_buf);
    client->send(json_buf,strlen(json_buf));    //点击发送按钮后,调用send方法发送已经序列化的json字符串
    delete[] json_buf;
}

