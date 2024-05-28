#ifndef PERSONALPAGECONTROLLER_H
#define PERSONALPAGECONTROLLER_H

#include <QQmlEngine>
class PersonalPageController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString netname READ netname WRITE setNetname NOTIFY netnameChanged)
    Q_PROPERTY(QString netnumber READ netnumber WRITE setNetnumber NOTIFY netnumberChanged)
    QML_ELEMENT
public:
    PersonalPageController(QObject *parent = nullptr);

    Q_INVOKABLE void initPersonalData();
    Q_INVOKABLE void test();
    void setNetname(const QString str);
    QString netname()const;
    void setNetnumber(const QString number);
    QString netnumber()const;


signals:
    void  netnameChanged(const QString netname);
    void  netnumberChanged(const QString netnumber);

private:

    QString m_name;
    QString m_number;

};

#endif // PERSONALPAGECONTROLLER_H
