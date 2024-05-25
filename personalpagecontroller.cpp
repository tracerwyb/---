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
