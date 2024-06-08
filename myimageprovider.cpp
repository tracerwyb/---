#include "myimageprovider.h"

MyImageProvider *MyImageProvider::m_myImageProvider=nullptr;
MyImageProvider::MyImageProvider():QQuickImageProvider(QQuickImageProvider::Pixmap) {}


QPixmap MyImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(requestedSize)
    Q_UNUSED(size)
    QPixmap p("/run/media/root/study/tempWechat/WeChat-Imitate-Client/assets/Picture/avatar/avater1.jpg");
    if(id=="avater"){
        return m_avater;
    }

}


void MyImageProvider::setAvater(QPixmap avater)
{
    m_avater=avater;
}

MyImageProvider *MyImageProvider::getInstance()
{
    if(m_myImageProvider == nullptr){
        m_myImageProvider = new MyImageProvider();
    }
    return m_myImageProvider;
}
