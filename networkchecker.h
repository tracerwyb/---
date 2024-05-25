#ifndef NETWORKCHECKER_H
#define NETWORKCHECKER_H
#endif // NETWORKCHECKER_H
#include <QCoreApplication>
#include <QDebug>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QTimer>

class NetworkChecker : public QObject
{
    Q_OBJECT

public:
    NetworkChecker(QObject *parent = nullptr)
        : QObject(parent)
    {
        manager = new QNetworkAccessManager(this);
        connect(manager, &QNetworkAccessManager::finished, this, &NetworkChecker::onNetworkReply);
    }

    void checkNetwork()
    {
        QNetworkRequest request(QUrl("http://www.google.com")); // 你可以替换为其他可靠的网站
        manager->get(request);
    }

signals:
    void networkStatus(bool connected);

private slots:
    void onNetworkReply(QNetworkReply *reply)
    {
        if (reply->error() == QNetworkReply::NoError) {
            // 如果收到了响应，则认为联网
            emit networkStatus(true);
        } else {
            // 如果出现错误，则认为未联网
            emit networkStatus(false);
        }
        reply->deleteLater();
    }

private:
    QNetworkAccessManager *manager;
};

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    NetworkChecker networkChecker;
    QObject::connect(&networkChecker, &NetworkChecker::networkStatus, [](bool connected) {
        if (connected) {
            qDebug() << "手机已连接到互联网";
        } else {
            qDebug() << "手机未连接到互联网";
        }
        QCoreApplication::quit();
    });

    // 检查网络连接状态
    networkChecker.checkNetwork();

    return a.exec();
}
