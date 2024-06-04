#ifndef PERSONALPAGECONTROLLER_H
#define PERSONALPAGECONTROLLER_H

#include <QQmlEngine>
class PersonalPageController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString netname READ netname WRITE setNetname NOTIFY netnameChanged)
    Q_PROPERTY(QString netnumber READ netnumber WRITE setNetnumber NOTIFY netnumberChanged)
    Q_PROPERTY(QString acceptid READ acceptid WRITE setAcceptid NOTIFY acceptidChanged)
    Q_PROPERTY(QString acceptmsg READ acceptmsg)
    Q_PROPERTY(QString sendmsg WRITE setSendmsg NOTIFY sendmsgChanged)
    QML_ELEMENT
public:
    PersonalPageController(QObject *parent = nullptr);

    Q_INVOKABLE void initPersonalData();
    Q_INVOKABLE void test();
    Q_INVOKABLE void send();
    Q_INVOKABLE void inite();
    Q_INVOKABLE void sendImage();
    void setNetname(const QString str);
    QString netname()const;
    void setNetnumber(const QString number);
    QString netnumber()const;
    void setAcceptid(const QString number);
    QString acceptid()const;
    static QString acceptmsg();
    void setSendmsg(const QString sendmsg);

    static void setAcceptmsg(std::string acmsg);

signals:
    void  netnameChanged(const QString netname);
    void  netnumberChanged(const int netnumber);
    void  acceptidChanged(const int acceptid);
    void  sendmsgChanged(const QString sendmsg);
    void  acceptmsgChanged(const QString msg);
private:

    QString m_name;
    int m_number;
    int m_acceptid;
    QString m_sendmsg;
    static QString m_acceptmsg;
    static PersonalPageController *ppc;
};

#endif // PERSONALPAGECONTROLLER_H
