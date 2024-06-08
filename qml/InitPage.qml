import QtQuick
import QtQuick.Controls
import UIControl 1.0
ApplicationWindow{
    id:init

    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    title: qsTr("Wechat")

    Loader{
        anchors.fill: parent
        id:initloder
        source: ""
    }

    PersonalPageController{
        id:personalctrller
    }
    Rectangle{
        id:initRectangle
        anchors.fill: parent
        // color: "#ededed"
        Image {
            id: backg
            anchors.fill: parent
            // sourceSize: Qt.size(parent.width,parent.height)
            source: "qrc:/assets/Picture/icons/bg.jpeg"
        }
        Column{
            id:initColumn
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Rectangle{
                id:inputRecid
                width: init.width/10*8
                height: init.height/10
                opacity: 0.7
                Row{
                    id:idrow
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    // spacing: inputRecid.width/10
                    Rectangle{
                        width: inputRecid.width/5
                        height: inputRecid.height/2
                        color: "transparent"
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            id: myidtext
                            text: qsTr("账号:")
                            font.pixelSize: 22
                    }
                    }
                    Rectangle{
                        width: inputRecid.width/10*7
                        height: inputRecid.height/2
                        color: "transparent"
                        border.color: "black"
                        TextInput{
                            id:idtextinput
                            anchors.fill: parent
                            autoScroll: false
                            echoMode:TextInput.Normal
                            // maximumLength: 10
                            font.pixelSize: 22
                            horizontalAlignment: TextInput.AlignLeft
                            verticalAlignment: TextInput.AlignVCenter
                            leftPadding: 10
                            onAccepted: {
                                personalctrller.netnumber=text
                            }
                            validator: RegularExpressionValidator{
                                            regularExpression: /\b[1-9]\d{7}\b/
                                        }
                        }
                    }
                }
            }
            spacing: 10
            Rectangle{
                id:initbuttonRec
                width: init.width/10*8
                height: init.height/15
                color: "transparent"
                Button{
                    anchors.fill: parent
                    id:initbutton
                    background:Rectangle{
                        id:bgRec
                        anchors.fill: parent
                        color: "#3399FF"
                        radius: 5
                    }
                    onPressed: {
                        bgRec.color="#66B2FF"
                    }
                    onReleased: {
                        bgRec.color="#3399FF"
                    }

                    Text{
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        id:buttontext
                        text:qsTr("登陆")
                        font.pixelSize: 25
                        color: "white"
                    }

                    onClicked: {
                        personalctrller.netnumber = idtextinput.text
                        initloder.source="Main.qml"
                        initRectangle.visible=false

                        personalctrller.test()              //与服务器建立连接
                        listenThread.startThread()          //开启监听线程，从套接字里读数据

                        personalctrller.send()              //发送本人的id初始化在线列表
                        personalctrller.inite()            //测试,从服务端传头像过来初始化

                        messagePreviewPageController.setMyId(idtextinput.text)
                        fileTools.setMyId(idtextinput.text)

                        fileTools.initFiled(idtextinput.text)
                        messagePreviewPageController.getOfflineMessage();

                        communicationPageController.setSenderId(idtextinput.text);
                        console.log("当前用户："+communicationPageController.senderId.toString())
                    }
                }
            }
        }
    }

}
