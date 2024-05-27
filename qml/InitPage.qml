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
        color: "#ededed"
        Column{
            id:initColumn
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            Rectangle{
                id:inputRecid
                width: init.width/10*8
                height: init.height/10
                //color:"#FFAAFF"
                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    id:idrow
                    spacing: 25
                    Rectangle{
                        width: 50
                        height: inputRecid.height/2
                        // color: "#DEDEDE"
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            id: myidtext
                            text: qsTr("账号:")
                            font.pixelSize: 22
                    }
                    }
                    Rectangle{
                        width: inputRecid.width/5*4
                        height: inputRecid.height/2
                        // color: "#"
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
                    }
                }
            }
        }
    }

}