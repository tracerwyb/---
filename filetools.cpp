#include "filetools.h"
#include <QStandardPaths>
#include <QTextStream>
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
    QString newDirPathVedio = documentsPath + "/Vedio/" + SenderId;
    QDir newDirVedio(newDirPathVedio);
    if (!newDirVedio.exists()) {
        newDirVedio.mkpath(".");
    }
    QString newDirPathAudio = documentsPath + "/Audio/" + SenderId;
    QDir newDirAudio(newDirPathAudio);
    if (!newDirAudio.exists()) {
        newDirAudio.mkpath(".");
    }
    QString newDirPathFriendReq = documentsPath + "/FriendReq/" + SenderId;
    QDir newDirFriendReq(newDirPathFriendReq);
    if (!newDirFriendReq.exists()) {
        newDirFriendReq.mkpath(".");
    }
}

// QString FileTools::openTextFile(QString fileType, QString filename)
// {
//     QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
//     QString newFilePath = documentsPath + "/" + fileType + "/" + filename;
//     QFile file(newFilePath);
//     if (file.open(QIODevice::ReadOnly)) {
//         QTextStream stream(&file);
//         QString messages = stream.readAll();
//         file.close();
//         qDebug() << "read local message!";
//         qDebug().noquote() << messages;
//         return messages;
//     } else {
//         qDebug() << "Failed to open file!";
//     }
//     return "";
// }

// char *FileTools::openMediaFile(QString fileType, QString filename)
// {
//     QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
//     QString newFilePath = documentsPath + "/" + fileType + "/" + filename;
//     QFile file(newFilePath);
//     if (file.open(QIODevice::ReadOnly)) {
//         QTextStream stream(&file);
//         char *mediaBuffer = new char[99999];
//         stream >> mediaBuffer;
//         file.close();
//         qDebug() << "read local message!";
//         //指针可能存在问题
//         return mediaBuffer;
//     } else {
//         qDebug() << "Failed to open file!";
//     }
//     return NULL;
// }
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
    if (jsonMessage["MessageType"] == "Vedio") {
        QString newFilePath = documentsPath + "/Vedio/" + myId + "/" + filename + ".json";
    }
    if (jsonMessage["MessageType"] == "Audio") {
        QString newFilePath = documentsPath + "/Audio/" + myId + "/" + filename + ".json";
    }

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
    std::string senderId;
    qDebug() << "store 1";
    if (jsonMessage["SenderId"].is_number()) {
        senderId = std::to_string(jsonMessage["SenderId"].get<int>());
    } else if (jsonMessage["SenderId"].is_string()) {
        senderId = jsonMessage["SenderId"].get<std::string>();
    } else {
        qDebug() << "SenderId is neither number nor string";
    }

    std::string receiverId;
    if (jsonMessage["ReceiverId"].is_number()) {
        receiverId = std::to_string(jsonMessage["ReceiverId"].get<int>());
    } else if (jsonMessage["ReceiverId"].is_string()) {
        receiverId = jsonMessage["ReceiverId"].get<std::string>();
    } else {
        qDebug() << "SenderId is neither number nor string";
    }

    qDebug() << "store 2";
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
        qDebug() << "store 3";
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
