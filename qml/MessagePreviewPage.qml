import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import QtQuick.Layouts
Rectangle{
    width: parent.width
    height: parent.height
    id:messagePreviewPage
    anchors.fill: parent
    visible: true
    property var jsonData: {"messagecontent":"string","messagetype":"Text","receiver":"22222","sender":"11111","sendtime":"2024-5-21 21:00"}
    readonly property url communicationPage_loader: "CommunicationPage.qml"

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
                    receiverid:"2222"
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
                   //保存id
                   Text{
                       id:receiver
                       text:receiverid
                       visible: false
                   }
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
                       width: 100
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
                           communicationPageController.setReceiverId(receiverid)
                           console.log(communicationPageController.receiverId);
                           communicationPageLoader.source=communicationPage_loader
                           //设置communication的receiverid-》communciation根据这个id去查找数据做准备
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
            function onMessageChangedd(){
               console.log("qml相应message改变，添加对象到view中")
               // var jsonString=JSON.stringify(jsonData)
               // console.log("QString",jsonString)
               // messagePreviewPageController.setMessages(jsonString);
               var jsonData=JSON.parse(messagePreviewPageController.getMessage());
                var ob={};
                if(jsonData.SenderId.toString()===messagePreviewPageController.myId){
                    //添加信息-
                    console.log(jsonData.ReceiverId)
                    ob.name = jsonData.ReceiverId.toString()
                    ob.receiverid=jsonData.ReceiverId.toString()
                    ob.imagesource="qrc:/assets/Picture/avatar/"+jsonData.ReceiverId+".jpg"
                }else{
                    console.log(jsonData.SenderId)
                    ob.name = jsonData.SenderId.toString()
                    ob.receiverid=jsonData.SenderId.toString()
                    ob.imagesource="qrc:/assets/Picture/avatar/"+jsonData.SenderId+".jpg"
                }
                ob.messageinfo =jsonData.MessageContent.toString()
                ob.sendtime =jsonData.SendTime.toString()
               //查找头像
                messageModel.insert(messagePreviewPageController.personCount,ob)
               //  messageModel.insert(ob)
               //按顺序添加到消息列表
            }


            Component.onCompleted: {
                messagePreviewPageController.onMessageChanged.connect(onMessageChangedd)
                messagePreviewPageController.initMessagePreviewPage();
                console.log('initMessagePreviewPage')

            }
    }
}
