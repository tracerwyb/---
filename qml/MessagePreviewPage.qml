import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import QtQuick.Layouts
Rectangle{
    width: parent.width
    height: parent.height
    id:messagePreviewPage
    property var jsonData: {"messagecontent":"string","messagetype":"Text","receiver":"22222","sender":"11111","sendtime":"2024-5-21 21:00"}
    readonly property url communicationPage_loader: "CommunicationPage.qml"
    //Qstring赋值VAR JSONDATA看看是什么，JSONDATA是JSON还是QSTRING
    Loader{
        id:messagePreviewPageLoader
        anchors.fill: parent
    }

    Rectangle{
        //显示优先级
        z:2
        id: messagePreviewPageTitle
        width: messagePreviewPage.width
        height: messagePreviewPage.height * barheight_rate

        anchors.horizontalCenter: parent.horizontalCenter
        y: 0
        color: "#ededed"
        visible: true
        Text{
            width: parent.width
            height: parent.height / 1.5
            y:parent.height - parent.height / 1.5

            text: qsTr("微信")
            font.pixelSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter // 水平居中
            verticalAlignment: Text.AlignVCenter
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

    Rectangle {
        id: content
        width: messagePreviewPage.width
        height: messagePreviewPage.height - messagePreviewPageTitle.height - pagebar.height
        y: messagePreviewPageTitle.height
        border.color: "black"
        Rectangle{
            id:messagedisplay
            width:parent.width
            height: parent.height
            //槽
            //添加element函数
            //连接MessagePreviewPageControler

            ListModel {
                id: messageModel
                ListElement {
                    name: "test"
                    messageinfo: "消息内容哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"
                    sendtime:"12:00"
                    imagesource:"qrc:/assets/Picture/avatar/hrx.jpg"
                    attributes: [
                        ListElement { description: "离线消息" },
                        ListElement { description: "在线消息" }
                    ]
                }
            }

            Component {
                id: messageDelegate
               Rectangle{
                   //border.color: "red"
                   //border.width: 1
                   id:message
                   width:messagedisplay.width
                   height:70
                   Row {
                       id:meaage_layout
                       width:messagedisplay.width
                       height:70
                       topPadding: 10
                       Row{
                           id:avatar_layout
                           width: 70
                           height: 70
                           leftPadding: 10
                           bottomPadding: 10
                           rightPadding: 10
                           Rectangle{
                               //缩略图本体
                               id:avatar
                               width: 50
                               height: 50
                               //border.color: "black"
                               //border.width: 0.5
                                Image {
                                    id: image
                                    source:imagesource
                                    asynchronous: true
                                    anchors.centerIn: parent
                                    width: 50
                                    height: 50
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
                        }
                       Column{
                           Text{
                               text: "Name "+name
                               font.pointSize: 20
                           }
                           Text{
                               text:truncateText(messageinfo,15)
                               function truncateText(str,maxLength){
                                   if(str.length>maxLength){
                                       return str.substring(0,maxLength)+"..."
                                   }
                                   return str
                               }
                           }
                       }

                   }
                   //分割线
                   Rectangle{
                       width: parent.width-70
                       height: 0.6
                       border.color: "#c7c7c7"
                       border.width: 0.6
                       anchors.right: parent.right
                       anchors.bottom:parent.bottom
                   }

                   Rectangle{
                       width: 70
                       height: 60
                       id:sendtime_layout
                       anchors.right: parent.right
                       anchors.top: parent.top
                       color:"transparent"
                       Text{
                           anchors.centerIn: parent
                           text:sendtime
                       }
                   }
                   TapHandler{
                       onTapped: {
                           message.border.color="red"
                           message.border.width=1
                           messagePreviewPageLoader.source=communicationPage_loader
                           messagePreviewPageTitle.visible=false
                           content.visible=false
                           pagebar.visible=false
                           //别名设置另一个界面的资源
                       }
                   }
               }
             }

            ListView {
                anchors.fill: parent
                model: messageModel
                delegate: messageDelegate
                ScrollBar.vertical: ScrollBar {
                           policy: ScrollBar.AsNeeded
                           width: 1
               }
            }
            Timer{
                interval: 2000
                running: true
                repeat: true
                onTriggered: {
                    messagePriviewPageController.messagesReceiver();
                }
            }
            //也可以是前端记录（判断是否已经出现，出现过就更新，没出现过就添加）

            Connections{
                target: messagePriviewPageController
                function onMessagesReceiver(personCount){console.log("111")
                    var jsonString=JSON.stringify(jsonData)
                    console.log("QString",jsonString)
                    messagePriviewPageController.setMessages(jsonString);
                    //添加信息
                    var ob={};
                    ob.name = jsonData.sender
                    ob.messageinfo =jsonData.messageContent
                    ob.sendtime = jsonData.sendTime
                    //查找头像
                    ob.imagesource="qrc:/assets/Picture/avatar/"+jsonData.sender+".jpg"
                    //按顺序添加到消息列表
                    messageModel.insert(messagePriviewPageController.personCount,ob)
                    messagePriviewPageController.setPersonCount(messagePriviewPageController.personCount+1)
                }
            }

        }
    }

    Rectangle{
        id: pagebar
        width: messagePreviewPage.width
        height: messagePreviewPage.height * barheight_rate
        //color: "#ededed"
        anchors.horizontalCenter: messagePreviewPage.horizontalCenter
        y: messagePreviewPage.height-height
        visible: true

        TabBar{
            height: parent.height
            y: 0
            // 设置TabBar的背景色
            background: Rectangle {
                color: "#ededed" // 更改为你想要的颜色
            }
            Repeater{
                model: [qsTr("微信"),qsTr("通讯录"),qsTr("我")]
                TabButton{
                    width: text_1.width
                    height:text_1.height
                    x: index * width
                    Text{
                        id:text_1
                        width:pagebar.width / page_num
                        height:pagebar.height
                        text: modelData
                        horizontalAlignment: Text.AlignHCenter // 水平居中
                        verticalAlignment: Text.AlignVCenter

                    }
                }
                TabButton{
                    width: text_2.width
                    height:text_2.height
                    x: index * width
                    Text{
                        id:text_2
                        width:pagebar.width / page_num
                        height:pagebar.height
                        text: modelData
                        horizontalAlignment: Text.AlignHCenter // 水平居中
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                TabButton{
                    width: text_3.width
                    height:text_3.height
                    x: index * width
                    Text{
                        id:text_3
                        width:pagebar.width / page_num
                        height:pagebar.height
                        horizontalAlignment: Text.AlignHCenter // 水平居中
                        verticalAlignment: Text.AlignVCenter
                        text: modelData
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
        messagePreviewPageTitle.visible=true
        content.visible=true
        pagebar.visible=true
    }
}

