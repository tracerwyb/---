#ifndef FILETOOLS_H
#define FILETOOLS_H
#include <QDir>
#include <QFile>
#include <nlohmann/json.hpp>
class FileTools : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString myId READ getMyId WRITE setMyId)
public:
    static FileTools *getInstance();
    FileTools();
    // QString openTextFile(QString fileType, QString filename);
    // char *openMediaFile(QString fileType, QString filename);

    Q_INVOKABLE void initFiled(QString SenderId);
    nlohmann::json saveMessageMedia(nlohmann::json jsonMessage, char *mediaBuffer, QString filename);
    void saveMessageText(nlohmann::json jsonMessage, QString filename);
    void saveMessage(std::string str);
    QVector<QString> getFirstInfos();
    QString getInfo(QString filePath);

    QVector<QString> getCommunciationInfos(QString senderId, QString receiverId);
    Q_INVOKABLE void saveRequest(nlohmann::json jsonMessage, QString filename);
    Q_INVOKABLE QVector<QString> getReq(QString filename);
    Q_INVOKABLE void modifyRelation(nlohmann::json jsonMessage, QString filename, QString relation);

    Q_INVOKABLE QString getMyId() { return myId; }
    Q_INVOKABLE void setMyId(QString str) { myId = str; };

private:
    static FileTools *m_fileTools;
    QString myId;
};

#endif // FILETOOLS_H
