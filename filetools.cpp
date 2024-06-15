//该cpp文件有大量重复代码，根据请求类型判断使用不同的filename来控制数据的存储和读取
#include "filetools.h"
#include <QBuffer>
#include <QByteArray>
#include <QDataStream>
#include <QFile>
#include <QPixmap>
#include <QStandardPaths>
#include <QTextStream>
#include "qpixmap.h"
#include <string>

FileTools *FileTools::m_fileTools;

FileTools *FileTools::getInstance()
{
    if (m_fileTools == nullptr) {
        m_fileTools = new FileTools();
    }
    return m_fileTools;
}
FileTools::FileTools() {}

void FileTools::initFiled(QString SenderId)
{
    // 获取手机上的 Documents 目录路径
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    // 创建一个新目录（如果不存在）
    QString newDirPath = documentsPath + "/Text/" + SenderId;
    QDir newDir(newDirPath);
    if (!newDir.exists()) {
        newDir.mkpath(".");
    }
    QString newDirPathPicture = documentsPath + "/Picture/" + SenderId;
    QDir newDirPicture(newDirPathPicture);
    if (!newDirPicture.exists()) {
        newDirPicture.mkpath(".");
    }
    // QString newDirPathVedio = documentsPath + "/Vedio/" + SenderId;
    // QDir newDirVedio(newDirPathVedio);
    // if (!newDirVedio.exists()) {
    //     newDirVedio.mkpath(".");
    // }
    // QString newDirPathAudio = documentsPath + "/Audio/" + SenderId;
    // QDir newDirAudio(newDirPathAudio);
    // if (!newDirAudio.exists()) {
    //     newDirAudio.mkpath(".");
    // }
    QString newDirPathFriendReq = documentsPath + "/FriendReq/" + SenderId;
    QDir newDirFriendReq(newDirPathFriendReq);
    if (!newDirFriendReq.exists()) {
        newDirFriendReq.mkpath(".");
    }
    QString newDirPathFriendInfo = documentsPath + "/FriendInfo/" + SenderId;
    QDir newDirFriendInfo(newDirPathFriendReq);
    if (!newDirFriendReq.exists()) {
        newDirFriendReq.mkpath(".");
    }
}

//多媒体转化未完成
nlohmann::json FileTools::saveMessageMedia(nlohmann::json jsonMessage,
                                           char *mediaBuffer,
                                           QString filename)
{
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString newFilePath;
    QString time = QString::fromStdString(jsonMessage["SendTime"]);

    if (jsonMessage["MessageType"] == "Picture") {
        QString newFilePath = documentsPath + "/Picture/" + myId + "/" + filename + ".json";
    }
    // if (jsonMessage["MessageType"] == "Vedio") {
    //     QString newFilePath = documentsPath + "/Vedio/" + myId + "/" + filename + ".json";
    // }
    // if (jsonMessage["MessageType"] == "Audio") {
    //     QString newFilePath = documentsPath + "/Audio/" + myId + "/" + filename + ".json";
    // }

    QFile file(newFilePath);
    if (!file.open(QIODevice::ReadWrite | QIODevice::Append)) {
        qDebug() << "Failed to open file: " << newFilePath;
    }
    QTextStream stream(&file);
    stream << mediaBuffer;
    file.close();
    jsonMessage["MessageContent"] = newFilePath.toStdString();
    saveMessageText(jsonMessage, filename);
    return jsonMessage;
}
void FileTools::saveMessageText(nlohmann::json jsonMessage, QString filename)
{
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    qDebug() << "store 文本消息";
    QString newFilePath = documentsPath + "/Text/" + myId + "/" + filename + ".json";
    qDebug() << newFilePath;

    QFile file(newFilePath);
    QTextStream stream(&file);

    if (!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
        qDebug() << "Failed to open file: ";
    }
    if (file.size() == 0) {
        qDebug() << "1";
        nlohmann::json jr = nlohmann::json::array();
        jr.push_back(jsonMessage);
        QString info = QString::fromStdString(jr.dump());
        stream << info;
    } else {
        //kong
        QString info = stream.readAll(); // 读取整个文件内容
        std::string str = info.toStdString();
        // 解析 JSON
        nlohmann::json ja = nlohmann::json::parse(str);
        file.close();
        int flags = 0;
        for (nlohmann::json &item : ja) {
            //有相同的
            if (item == jsonMessage) {
                flags = 1;
                break;
            }
        }
        if (flags == 0) {
            ja.push_back(jsonMessage);
        }
        info = QString::fromStdString(ja.dump());
        QFile filew(newFilePath);
        filew.open(QIODevice::WriteOnly | QIODevice::Text);
        file.resize(0);
        QTextStream streamw(&filew);
        streamw << info;
        filew.close();
    }
}

QVector<QString> FileTools::getFirstInfos()
{
    qDebug() << "正在遍历消息目录";
    QVector<QString> fristMessages;
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString folderPath = documentsPath + "/Text/" + myId;
    QDir directory(folderPath);
    qDebug() << "正在获取每个对话文件的路径";
    QStringList files = directory.entryList(QDir::Files);
    if (files.size() == 0) {
        return fristMessages;
    } else {
        foreach (QString filename, files) {
            QString filePath = folderPath + "/" + filename;
            qDebug() << filename;
            QString info = getInfo(filePath);
            fristMessages.push_back(info);
        }
    }
    return fristMessages;
}

void FileTools::saveRequest(nlohmann::json jsonMessage, QString filename)
{
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);

    qDebug() << "store 2";
    QString newFilePath = documentsPath + "/FriendReq/" + myId + "/" + filename + ".json";
    qDebug() << newFilePath;

    QFile file(newFilePath);
    QTextStream stream(&file);

    if (!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
        qDebug() << "Failed to open file: ";
    }
    if (file.size() == 0) {
        qDebug() << "1";
        nlohmann::json jr = nlohmann::json::array();
        jr.push_back(jsonMessage);
        QString info = QString::fromStdString(jr.dump());
        stream << info;
        file.close();
    } else {
        //kong
        QString info = stream.readAll(); // 读取整个文件内容
        std::string str = info.toStdString();
        // 解析 JSON
        nlohmann::json ja = nlohmann::json::parse(str);
        file.close();
        int flags = 0;
        for (nlohmann::json &item : ja) {
            //有相同的
            if (item == jsonMessage) {
                flags = 1;
                break;
            }
        }
        if (flags == 0) {
            ja.push_back(jsonMessage);
        }
        info = QString::fromStdString(ja.dump());
        QFile filew(newFilePath);
        filew.open(QIODevice::WriteOnly | QIODevice::Text);
        file.resize(0);
        QTextStream streamw(&filew);
        qDebug() << "store 3";
        streamw << info;
        filew.close();
    }
}

void FileTools::modifyRelation(nlohmann::json jsonMessage, QString filename, QString relation)
{
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);

    qDebug() << "store 2";
    QString newFilePath = documentsPath + "/FriendReq/" + myId + "/" + filename + ".json";
    qDebug() << newFilePath;

    QFile file(newFilePath);
    QTextStream stream(&file);

    //kong
    QString info = stream.readAll(); // 读取整个文件内容
    std::string str = info.toStdString();
    // 解析 JSON
    nlohmann::json ja = nlohmann::json::parse(str);
    file.close();
    int flags = 0;
    for (nlohmann::json &item : ja) {
        //有相同的
        if (item == jsonMessage) {
            item["relation"] = relation.toStdString();
            break;
        }
    }
}
QString FileTools::getInfo(QString filePath)
{
    qDebug() << "正在获取消息";
    QString info;
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file:" << filePath;
    }
    // 读取文件内容
    QTextStream stream(&file);
    QString tempInfo = stream.readAll();
    std::string str = tempInfo.toStdString();
    nlohmann::json jr = nlohmann::json ::parse(str);
    qDebug() << "正在获取最后一条消息";
    nlohmann::json frist = jr.back();
    info = QString::fromStdString(frist.dump());
    file.close();
    return info;
}
QString FileTools::saveImageA(QString filePath)
{
    QFile filetemp(filePath);

    if (!filetemp.exists()) {
        qDebug() << "File does not exist:" << filePath;
    }
    qDebug() << "qqqqqqqqqqq";
    // 尝试加载图片
    QImage image(filePath);

    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString newFilePath = documentsPath + "/Picture/" + myId + "/temp" + +".jpg";
    image.save(newFilePath);
    return newFilePath;
}

void FileTools::deleteImageA(QString filePath)
{
    QFile filetemp(filePath);
    filetemp.remove();
}
// QByteArray FileTools::getPixmapAsBinary(QString filePath)
// {
//     QFile file(filePath);

//     if (!file.exists()) {
//         qDebug() << "File does not exist:" << filePath;
//         return QByteArray();
//     }
//     qDebug() << "qqqqqqqqqqq";
//     // 尝试加载图片
//     QPixmap pixmap(filePath);
//     if (pixmap.isNull()) {
//         qDebug() << "Failed to load pixmap from file:" << filePath;
//         return QByteArray();
//     }

//     QByteArray byteArray;
//     QBuffer buffer(&byteArray);
//     buffer.open(QIODevice::WriteOnly);
//     pixmap.save(&buffer, "JPG"); // 或者您可以选择其他格式，如 "JPG"
//     qDebug() << "ssssssssssse:" << byteArray.size();
//     buffer.close();

//     return byteArray;
// }
char *FileTools::getPixmapAsBinary(QString filePath)
{
    QFile file(filePath);

    if (!file.exists()) {
        qDebug() << "File does not exist:" << filePath;
    }
    qDebug() << "qqqqqqqqqqq";
    // 尝试加载图片
    QPixmap pixmap(filePath);
    QByteArray byteArray;
    QBuffer buffer(&byteArray);
    buffer.open(QIODevice::WriteOnly);
    pixmap.save(&buffer, "PNG");
    // 将 QPixmap 保存为 PNG 格式的字节数组
    //-----------------------------图片的转换
    const char *dataPtr = byteArray.constData();
    int dataSize = byteArray.size();

    // 分配内存并复制数据
    char *charData = new char[dataSize];
    memcpy(charData, dataPtr, dataSize);

    return charData;
}

//保存头像-----------获取头像
void FileTools::saveUserAvatar(QPixmap avatar, QString filename)
{
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString directoryPath = documentsPath + "/Picture/" + myId + "/";
    QString newFilePath = directoryPath + filename + ".jpg";
    QDir directory(directoryPath);
    if (!directory.exists()) {
        if (!directory.mkpath(directoryPath)) {
            qDebug() << "Failed to create directory:" << directoryPath;
            return;
        }
    }

    QImage image = avatar.toImage();
    QFile file(newFilePath);
    if (file.exists()) {
        qDebug() << "File already exists:" << newFilePath;
    } else {
        if (image.save(newFilePath)) {
            qDebug() << "Image saved successfully to:" << newFilePath;
        } else {
            qDebug() << "Failed to save image to:" << newFilePath;
        }
    }
    qDebug() << "保存头像结束" << directoryPath;
}

QString FileTools::avatarStroePath()
{
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString newFilePath = documentsPath + "/Picture/" + myId + "/";
    return newFilePath;
}
//-------------------
//-------------------获取nickname
void FileTools::saveFriendsInfo(nlohmann::json jsonMessage)
{
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString directoryPath = documentsPath + "/FriendInfo/" + myId + "/";
    QDir directory(directoryPath);

    if (!directory.exists()) {
        if (!directory.mkpath(directoryPath)) {
            qDebug() << "Failed to create directory: " << directoryPath;
            return;
        }
    }
    QString newFilePath = directoryPath + myId + ".json";
    QFile file(newFilePath);
    QTextStream stream(&file);
    if (!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
        qDebug() << "Failed to open file: ";
    }
    if (file.size() == 0) {
        qDebug() << "1";
        nlohmann::json jr = nlohmann::json::array();
        jr.push_back(jsonMessage);
        QString info = QString::fromStdString(jr.dump());
        stream << info;
    } else {
        //kong
        QString info = stream.readAll(); // 读取整个文件内容
        std::string str = info.toStdString();
        // 解析 JSON
        nlohmann::json ja = nlohmann::json::parse(str);
        file.close();
        int flags = 0;
        for (nlohmann::json &item : ja) {
            //有相同的
            if (item == jsonMessage) {
                flags = 1;
                break;
            }
        }
        if (flags == 0) {
            ja.push_back(jsonMessage);
        }
        info = QString::fromStdString(ja.dump());
        QFile filew(newFilePath);
        filew.open(QIODevice::WriteOnly | QIODevice::Text);
        file.resize(0);
        QTextStream streamw(&filew);
        streamw << info;
        filew.close();
    }
}
QString FileTools::getFriendNickname(QString friendId)
{
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString filePath = documentsPath + "/FriendInfo/" + myId + "/" + myId + +".json";
    QString info;
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file:" << filePath;
    }
    // 读取文件内容
    QTextStream stream(&file);
    QString tempInfo = stream.readAll();
    std::string str = tempInfo.toStdString();
    nlohmann::json ja = nlohmann::json ::parse(str);
    for (nlohmann::json &item : ja) {
        //有相同的
        if (QString::fromStdString(item["UserID"]) == friendId) {
            info = QString::fromStdString(item["U_Nickname"]);
            break;
        }
    }
    file.close();
    return info;
}
//------------------
QVector<QString> FileTools::getCommunciationInfos(QString senderId, QString receiverId)
{
    QVector<QString> messages;
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString filePath = documentsPath + "/Text/" + myId + "/" + senderId + receiverId + ".json";
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file:" << filePath;
    }
    QTextStream stream(&file);
    QString tempInfo = stream.readAll();
    std::string str = tempInfo.toStdString();
    nlohmann::json jr = nlohmann::json ::parse(str);
    // 格式
    for (nlohmann::json &messageObjec : jr) {
        messages.append(QString::fromStdString(messageObjec.dump()));
    }
    file.close();
    return messages;
}

QVector<QString> FileTools::getReq(QString filename)
{
    QVector<QString> messages;
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString filePath = documentsPath + "/FriendReq/" + myId + "/" + filename + ".json";

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug() << "Failed to open file:" << filePath;
    }
    if (file.size() == 0) {
        file.close();
    } else {
        QTextStream stream(&file);
        QString tempInfo = stream.readAll();
        std::string str = tempInfo.toStdString();
        nlohmann::json jr = nlohmann::json ::parse(str);
        // 格式
        for (nlohmann::json &messageObjec : jr) {
            messages.append(QString::fromStdString(messageObjec.dump()));
        }
        file.close();
    }

    return messages;
}
