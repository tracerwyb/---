import QtQuick

import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import QtQuick.Layouts

Rectangle  {
    width: parent.width
    height: parent.height
    visible: true
    id:communicationPage
    readonly property url messagePreviewPage_loader: "MessagePreviewPage.qml"
    readonly property url showFriend_loader: "showFriendPage.qml"

    property double barheight_rate: 0.06
    property var receiverAvatarSource
       //message-动态获取
    property var senderMessage
    property var receiverMessage

    property var nickname
    property var inputBoxHeight:50
    //信号-》json-》qml槽函数调用添加
    //function
    //判断是谁发的，
    function addItem(type,message) {
        // if(type==="sender")
        //     senderMessage=message
        // else
        //     receiverMessage=message

         var ob={};
         ob.cType = type
         ob.cMessage =message
         messageListModel.append(ob);
        //messageListModel.append({ "cType": type, "cMessage":qstringToStdString(message)});
        console.log(" add messages")
    }
    function sendMessage(type,message,data) {
        console.log("发送消息:", message);
        //判断网友是否在线，选择是否发送给服务端
        console.log(communicationPage.width)
        console.log(communicationPage.height)
        addItem(type,message)
     }
    Loader{
        id:communciationLoader
        anchors.fill: parent
    }


    //header
    Rectangle{
        z:1
        id: receiverTitleBorder
        width: communicationPage.width
        height: communicationPage.height * barheight_rate
        y:0
        color: "#ededed"
        border.color: "green"
        border.width: 1
        visible: true
        Rectangle{
            id:backMessagePreviewBottom
            height:receiverTitleBorder.height
            width: 40
            anchors.right: parent.right
            Rectangle {
                anchors.centerIn: parent
                id:backButtonBorder
                width: 30
                height: 30
                color:"transparent"
                Image {
                    anchors.fill: parent
                    source: "qrc:/assets/Picture/icons/to_personInfo.png"// 确保这里的路径是正确的，指向你的图片文件
                }
            TapHandler{
                onTapped: {
                    communciationLoader.source=showFriend_loader
                    receiverTitleBorder.visible=false
                    chatMessageDisplay.visible=false
                    inputBox.visible=false

                }
            }
         }
     }
        Rectangle{
            id:receiverNicknameBorder
            width: parent.width-80
            height: parent.height
            anchors.centerIn: parent
            border.color: "green"
            border.width: 1
            color:"transparent"
            Text{
                id:receiverNickname
                width: parent.width
                height: parent.height
                text: "hhh"//nickname
                font.pixelSize: 20
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter // 水平居中
                verticalAlignment: Text.AlignVCenter
            }
        }
        Rectangle{
            id:arriveReceiverPersonInfo
            width: 40
            height: parent.height
            anchors.left: parent.left
            border.color: "green"
            border.width: 1
            Rectangle {
                anchors.centerIn: parent
                id:arriveReceiverPersonInfoBorder
                width: 30
                height: 30
                color:"transparent"
                Image {
                    anchors.fill: parent
                    source: "qrc:/assets/Picture/icons/back.png"// 确保这里的路径是正确的，指向你的图片文件
                }
                TapHandler{
                    onTapped: {
                        communciationLoader.source=messagePreviewPage_loader
                        receiverTitleBorder.visible=false
                        chatMessageDisplay.visible=false
                        inputBox.visible=false

                    }
                }
            }
        }
    //边界线
    Rectangle{
        width: parent.width
        height: 0.6
        border.color: "#c7c7c7"
        border.width: 0.6
        anchors.bottom:parent.bottom
    }
}

    Rectangle{
            id:chatMessageDisplay
            width: parent.width
            height: parent.height-communicationPage.height * barheight_rate-50
            color:"transparent"
            border.color: "green"
            border.width: 1
            y:communicationPage.height * barheight_rate
            visible: true

            ListView {
                id: messageListView
                anchors.fill: parent
                model:ListModel{
                    id:messageListModel
                 }
                spacing:10

                ScrollBar.vertical: ScrollBar {
                           policy: ScrollBar.AsNeeded
                           width: 1
                }
                delegate:Item{
                    Text{
                        id:test
                        text:cMessage
                        width:210
                        wrapMode: Text.Wrap
                        font.pointSize: 20
                        padding: 10
                        visible: false
                    }
                    width: messageListView.width
                    height: test.contentHeight+20
                    Loader {
                    sourceComponent: {
                        if(sourceComponent==senderMessageDelegate)
                        {
                            item.senderCmessage=cMessage
                        }
                         if(sourceComponent==receiverMessageDelegate)
                         {
                             item.receiverCmessage=cMessage
                         }
                        cType === "sender" ? senderMessageDelegate : receiverMessageDelegate
                    }
                }

                }
                //sender
                Component{
                    id:senderMessageDelegate
                    Rectangle{
                        id:senderMessageBorder
                        width: messageListView.width
                        height: senderinfo.contentHeight+20
                        border.color: "red"
                        border.width: 1
                        property  var senderCmessage:"hahaha"
                        Rectangle{
                            //缩略图本体
                            id:avatar
                            width: 50
                            height: 50
                            border.color: "black"
                            border.width: 0.5
                            anchors.rightMargin: 10
                            anchors.right: parent.right
                            Image {
                                 id: image
                                 source:"qrc:/assets/Picture/avatar/11111.jpg"
                                 asynchronous: true
                                 anchors.centerIn: parent
                                 width: 40
                                 height: 40
                                 //使用PreserveAspectFit确保在原始比例下不会变形
                                 fillMode: Image.PreserveAspectFit
                                 clip: true
                                 visible: false //因为显示的是OpacityMask需要false
                             }

                             //圆角遮罩Rectangle
                             Rectangle {
                                 id: maskRec
                                 anchors.centerIn: parent
                                 width: image.width
                                 height: image.height
                                 color:"transparent"
                                 Rectangle {
                                     anchors.centerIn: parent
                                     width: image.paintedWidth
                                     height: image.paintedHeight
                                     color:"black"
                                     radius: 10
                                 }
                                 visible: false //因为显示的是OpacityMask需要false
                             }

                             //遮罩后的图案
                             OpacityMask {
                                 id: mask
                                 anchors.fill: image
                                 source: image
                                 maskSource: maskRec
                             }
                        }
                        Rectangle{
                            id:senderMessageInfoBorder
                           // width: Math.min( parent.width-140,info.implicitWidth)
                            width: senderinfo.contentWidth+20
                            height: senderinfo.contentHeight+20
                            anchors.right: parent.right
                            anchors.rightMargin: 70
                            color: "#DCF8C6"
                            radius: 10
                            border.color: "#9EDD89"
                            border.width: 1
                            Text{
                                id:senderinfo
                                width:210
                                anchors.left: parent.left
                                wrapMode: Text.Wrap
                                font.pointSize: 20
                                padding: 10
                                text:senderCmessage
                            }
                        }
                    }
                }
                //receiver
                Component{
                    id:receiverMessageDelegate
                    Rectangle{
                        id:receiverMessageBorder
                        width: messageListView.width
                        height: receiverinfo.contentHeight+20
                        border.color: "red"
                        border.width: 1

                        property  var receiverCmessage:"hahahssssa"
                        Rectangle{
                            //缩略图本体
                            id:avatar
                            width: 50
                            height: 50
                            border.color: "black"
                            border.width: 0.5
                            anchors.leftMargin: 10
                            anchors.left: parent.left
                            Image {
                                 id: image
                                 source:"qrc:/assets/Picture/avatar/11111.jpg"
                                 asynchronous: true
                                 anchors.centerIn: parent
                                 width: 40
                                 height: 40
                                 //使用PreserveAspectFit确保在原始比例下不会变形
                                 fillMode: Image.PreserveAspectFit
                                 clip: true
                                 visible: false //因为显示的是OpacityMask需要false
                             }

                             //圆角遮罩Rectangle
                             Rectangle {
                                 id: maskRec
                                 anchors.centerIn: parent
                                 width: image.width
                                 height: image.height
                                 color:"transparent"
                                 Rectangle {
                                     anchors.centerIn: parent
                                     width: image.paintedWidth
                                     height: image.paintedHeight
                                     color:"black"
                                     radius: 10
                                 }
                                 visible: false //因为显示的是OpacityMask需要false
                             }

                             //遮罩后的图案
                             OpacityMask {
                                 id: mask
                                 anchors.fill: image
                                 source: image
                                 maskSource: maskRec
                             }
                        }
                        Rectangle{
                            id:receiverMessageInfoBorder
                           // width: Math.min( parent.width-140,info.implicitWidth)
                            width: receiverinfo.contentWidth+20
                            height: receiverinfo.contentHeight+20
                            anchors.left: parent.left
                            anchors.leftMargin: 70
                            color: "#DCF8C6"
                            radius: 10
                            border.color: "#9EDD89"
                            border.width: 1
                            Text{
                                id:receiverinfo
                                width:210
                                anchors.left: parent.left
                                wrapMode: Text.Wrap
                                font.pointSize: 20
                                padding: 10
                                text:receiverCmessage
                            }
                        }
                    }
                }
                //time
                Component{
                    id:communciateTimeDelegate
                    Rectangle{
                        id:communciateTimeBorder
                        width: messageListView.width
                        height: 15//10-15
                        color: "green"
                        //聊天开始添加一个，后面定时添加
                        Text{
                            id:currenttime
                            text:"2024.05.24:24:00"
                        }
                    }
                }
                Component.onCompleted: {
                    console.log("messages")
                    addItem("sender","hahaha");
                    addItem("receiver","hahaha");
                    addItem("sender","hahaha");
                }
            }
        }

    //其中的圆形按钮都可以是添加Rectangle图片！对其做TapHandler处理
    Rectangle{
               id:inputBox
               width: parent.width
               height: inputBoxHeight
               border.color: "red"
               anchors.bottom: parent.bottom
               Row {
                   leftPadding: 5
                   //语音
                   Rectangle {
                       id:audioBorder
                       width: communicationPage.width*0.11
                       height: inputBoxHeight
                       border.color: "yellow"
                       border.width: 2
                       color:"transparent"
                       Rectangle {
                           anchors.bottom: parent.bottom
                           id:audioButton
                           width: 40
                           height: 40
                           color:"transparent"
                           Image {
                               width: 30
                               height: 30
                               source: "qrc:/assets/Picture/icons/voice.png"// 确保这里的路径是正确的，指向你的图片文件
                           }
                       }
                   }
                   //消息框
                   Rectangle{
                       id:inputFeildBorderLayout
                       width:communicationPage.width*0.64
                       height:inputBoxHeight
                       Rectangle{
                              id:inputFeildBorder
                              width:communicationPage.width*0.6
                              height:inputBoxHeight-10
                              anchors.centerIn: parent
                              TextField {
                                  id: inputField
                                  anchors.fill: parent
                                  width: parent.width
                                  font.pointSize: 18
                                  wrapMode: Text.Wrap  // 设置换行模式
                                  onTextChanged: {
                                      inputBoxHeight=inputField.contentHeight+25
                                      if(inputField.text==="")
                                          inputBoxHeight=50
                              }
                          }
                       }
                   }
                   //更多按钮
                   Rectangle {
                       id:moreChatFunctionBorder
                       width: communicationPage.width*0.11
                       height: inputBoxHeight
                       border.color: "yellow"
                       border.width: 2
                       color:"transparent"
                       Rectangle {
                           anchors.bottom: parent.bottom
                           id:moreChatFunctionButton
                           width: 40
                           height: 40
                           radius: width / 2  // 确保圆形按钮
                           color:"transparent"
                           Image {
                               width: 30
                               height: 30
                               source: "qrc:/assets/Picture/icons/more.png" // 确保这里的路径是正确的，指向你的图片文件
                           }
                       }
                   }
                   //发送消息按钮
                   Rectangle {
                       id:senderMessageBorder
                       width: communicationPage.width*0.11
                       height: inputBoxHeight
                       border.color: "yellow"
                       border.width: 2
                       color:"transparent"
                       Rectangle {
                           anchors.bottom: parent.bottom
                           id:senderMessageButton
                           width: 40
                           height: 40
                           radius: width / 2  // 确保圆形按钮
                           color:"transparent"
                           Image {
                               width: 30
                               height: 30
                               source: "qrc:/assets/Picture/icons/send.png" // 确保这里的路径是正确的，指向你的图片文件
                               }
                       }
                       TapHandler{
                           onTapped: {
                               inputBoxHeight=50
                               // 获取当前日期和时间
                               var currentDate = new Date();
                               // 自定义格式化字符串
                               var currentFormattedDate = Qt.formatDateTime(currentDate, "yyyy-MM-dd hh:mm:ss");
                               if(inputField.text!==""){
                                   sendMessage("sender",inputField.text,currentFormattedDate)
                               }
                               console.log(inputField.text)
                               // 清空输入框
                               inputField.text = "";
                           }
                       }
                   }
               }

               //边界线
                    Rectangle{
                   width: parent.width
                   height: 0.6
                   border.color: "#c7c7c7"
                   border.width: 0.6
                   anchors.top:parent.top
               }
      }
    Component.onCompleted: {
        receiverTitleBorder.visible=true
        chatMessageDisplay.visible=true
        inputBox.visible=true
    }
}
