#ifndef GETFIRSTLETTER_H
#define GETFIRSTLETTER_H

#include <QObject>

class GetFirstLetter : public QObject
{
public:
    GetFirstLetter();
    Q_INVOKABLE static char getFirstWord(const QString &str);
    Q_INVOKABLE static char FirstLetter(const QString &str);
};

#endif // GETFIRSTLETTER_H
