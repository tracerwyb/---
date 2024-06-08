import QtQuick
import QtCore
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtMultimedia

Rectangle  {
    z:2
    width: parent.width
    height: parent.height
    visible: true
    id:communicationPage
    readonly property url messagePreviewPage_loader: "MessagePreviewPage.qml"

    property double barheight_rate: 0.06

    property var receiverAvatarSource

   //message-动态获取-收信人的昵称
    property string nickname:"test"

    //控制视频全屏
    property  bool isFullScreen: false
    //输入栏的固定高度
    property int inputBoxHeight:50

    //控制moreFIleDialog状态的变量
    property bool moreState: false

    //信号-》json-》qml槽函数调用添加
    //function
    //判断是谁发的，
    function  addItem(pType,mType,message,time) {
        // if(type==="sender")
        //     senderMessage=message
        // else
        //     receiverMessage=message

         var ob={};
         ob.pType = pType
         ob.mType =mType
         ob.message=message
         ob.time=time
         messageListModel.append(ob);
        //messageListModel.append({ "cType": type, "cMessage":qstringToStdString(message)});
        console.log(" add messages")
        console.log(message)
    }

    function sendMessage(pType,mType,message,time) {

        console.log("发送消息:", message);
        //判断网友是否在线，选择是否发送给服务端
        console.log(communicationPage.width)
        console.log(communicationPage.height)
        console.log(pType,mType,message,time)
        addItem(pType,mType,message,time);
     }
    Loader{
        id:showFriendPageLoader
        asynchronous: true
        anchors.fill: parent
    }
    //header
    Rectangle{
            id: receiverTitleHeader
            width: communicationPage.width
            height: communicationPage.height * barheight_rate
            y:0
            z:1
            visible: true
            Rectangle{
                id:arriveReceiverPersonInfo
                height:receiverTitleHeader.height
                width: 40
                anchors.right: parent.right
                Rectangle {
                    anchors.centerIn: parent
                    id:arriveReceiverPersonInfoBorder
                    width: 30
                    height: 30
                    color:"transparent"
                    Image {
                        width: 20
                        height: 20
                        anchors.centerIn: parent
                        source: "qrc:/assets/Picture/icons/to_personInfo.png"// 确保这里的路径是正确的，指向你的图片文件
                    }
                    TapHandler{
                        onTapped: {
                            receiverTitleHeader.visible=false
                            chatMessageDisplay.visible=false
                            inputBox.visible=false

                            showFriendPageLoader.source=showFriend_loader
                            showFriendPageHeader.visible=true
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
                        text: nickname
                        font.pixelSize: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter // 水平居中
                        verticalAlignment: Text.AlignVCenter
                    }
                }


                Rectangle{
                    id:backMessagePreviewBottom
                    width: 40
                    height: receiverTitleHeader.height
                    anchors.left: parent.left
                    border.color: "green"
                    border.width: 1
                    Rectangle {
                        anchors.centerIn: parent
                        id:backMessagePreviewBottomBorder
                        width: 30
                        height: 30
                        color:"transparent"
                        anchors.left: parent.left
                        Image {
                            width: 20
                            height: 20
                            anchors.centerIn: parent
                            source: "qrc:/assets/Picture/icons/back.png"// 确保这里的路径是正确的，指向你的图片文件
                        }
                        TapHandler{
                            onTapped: {
                                loader.source=messagePreviewPage_loader
                                communicationPageLoader.source=""
                                communicationPage.visible=false
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
            id:showFriendPageHeader
            width: communicationPage.width
            height: communicationPage.height * barheight_rate
            y:0
            visible: false
            Row{
                width: parent.width
                height: parent.height
                Rectangle{
                    height:30
                    width:30
                    Image{
                        height:20
                        width:20
                        id: back_img
                        anchors.centerIn: parent
                            source: "qrc:/assets/Picture/icons/back.png"
                        }
                    TapHandler{
                        onTapped: {
                            showFriendPageHeader.visible=false
                            showFriendPageLoader.source=""
                            chatMessageDisplay.visible=true
                            receiverTitleHeader.visible=true
                            inputBox.visible=true
                        }
                    }
                  }
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
                delegate:senderMessageDelegate
                Component.onCompleted: {
                    console.log("messages")
                    addItem("sender","Text","HAHAHA","2024-5-21 21:00");
                    addItem("receiver","Text","XIXIXI","2024-5-21 21:00");
                    addItem("sender","Text","ZEZEZE","2024-5-21 21:00");
                }
            }
            Component{
                id:senderMessageDelegate
                Rectangle{
                    id:senderMessageBorderComponent
                    width: messageListView.width
                    height: senderinfo.contentHeight+20
                    border.color: "red"
                    border.width: 1
                    Rectangle{
                        //缩略图本体
                        id:avatar
                        width: 50
                        height: 50
                        border.color: "black"
                        border.width: 0.5
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
                        color: "#DCF8C6"
                        radius: 10
                        border.color: "#9EDD89"
                        border.width: 1
                        Text{
                            id:senderinfo
                            width:210
                            anchors.left: parent.left
                            wrapMode: Text.Wrap
                            text: message
                            font.pointSize: 20
                            padding: 10
                            visible: false
                           // text:message
                        }
                        Rectangle{
                            id:picture
                            width: 100
                            height: 150
                            border.color: "#9EDD89"
                            border.width: 1
                            Image{
                                id:senderinfo_Pic
                                anchors.fill: parent
                                source:Qt.resolvedUrl(message)
                                fillMode: Image.PreserveAspectFit
                                visible: true
                            }
                            TapHandler {
                                onTapped:{
                                    if(isFullScreen===false){
                                        imageViewBorder.visible=true;
                                        imageViewForMax.source=senderinfo_Pic.source;
                                        //imageViewForMax.visible=true;
                                    }
                                }
                            }

                        }

                        Rectangle{
                            id:player
                            width: 100
                            height: 150
                            border.color: "#9EDD89"
                            border.width: 1
                            color: "black"
                            Image{
                                id:mediaPlayer_vedio
                                anchors.fill: parent
                                source:Qt.resolvedUrl(message)
                                fillMode: Image.PreserveAspectFit
                                visible: false
                            }
                            Text{
                                id:playerSign
                                anchors.centerIn: parent
                            }
                            TapHandler {
                                onTapped:{
                                    if(isFullScreen===false && mType==="Vedio"){
                                        vedioView.visible=true;
                                        playerSign.text= "点击播放视频"
                                        mediaPlayer_vedioM.source=mediaPlayer_vedio.source;
                                        progressSlider.visible=true
                                        mediaPlayer_vedioM.play()
                                     }
                                    if(mType==="Audip"){
                                         mediaPlayer_vedioM.source=mediaPlayer_vedio.source;
                                         playerSign.text= "点击播放语音"
                                    }
                                }
                            }
                            Component.onCompleted: {
                                if(mType==="Vedio")
                                    playerSign.text= "点击播放视频"
                                if(mType==="Audip")
                                     playerSign.text= "点击播放语音"
                            }
                        }
                        Component.onCompleted:  {
                                if(pType=="receiver"){
                                    avatar.anchors.leftMargin=10
                                    avatar.anchors.left= parent.left
                                    senderMessageInfoBorder.anchors.left=parent.left
                                    senderMessageInfoBorder.anchors.leftMargin=70
                                }
                                if(pType==="sender"){
                                    avatar.anchors.rightMargin=10
                                    avatar.anchors.right=parent.right
                                    senderMessageInfoBorder.anchors.right= parent.right
                                    senderMessageInfoBorder.anchors.rightMargin= 70
                                }
                                if(mType==="Picture"){
                                    senderMessageInfoBorder.width=100
                                    senderMessageInfoBorder.height=150
                                    senderMessageBorderComponent.height=150
                                    picture.visible=true
                                    player.visible=false
                                    senderinfo.visible=false
                                }
                                if(mType==="Vedio"){
                                    senderMessageInfoBorder.width=100
                                    senderMessageInfoBorder.height=150
                                    senderMessageBorderComponent.height=150
                                    player.visible=true
                                    picture.visible=false
                                    senderinfo.visible=false
                                }
                                if(mType==="Text"){
                                    senderMessageBorderComponent.height=senderinfo.contentHeight+20
                                    picture.visible=false
                                    player.visible=false
                                    senderinfo.visible=true

                                }
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
    }

    //其中的圆形按钮都可以是添加Rectangle图片！对其做TapHandler处理
    Rectangle{
               id:inputBox
               z:1
               width: parent.width
               height: inputBoxHeight+10
               border.color: "red"
               anchors.bottom: parent.bottom
               Column{
                   Rectangle{
                       width: communicationPage.width
                       height: inputBoxHeight
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
                               TapHandler{
                                   onTapped: {
                                       if(moreState===false){
                                           inputBox.height=inputBoxHeight+200
                                           moreChoose.visible=true
                                           moreState=true
                                       }
                                       else{
                                           inputBox.height=inputBoxHeight
                                           moreChoose.visible=false
                                           moreState=false
                                       }
                                   }
                               }
                           }
                           //发送消息按钮
                            //发送消息按钮
                            //发送消息按钮
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
                                           // sendMessage("sender","Text",inputField.text,currentFormattedDate)
                                           //String->QString
                                           communicationPageController.setNewSendMessage(inputField.text);
                                           communicationPageController.sendNewMessage();
                                       }
                                       console.log(inputField.text)
                                       // 清空输入框
                                        //
                                       inputField.text = "";
                                   }
                               }
                           }
                       }
                   }

                   Rectangle{
                       id:moreChoose
                       width: communicationPage.width
                       height: 200
                       visible: false
                       Column{
                           Rectangle{
                               width: communicationPage.width
                               height: 100
                               Row{
                                   anchors.fill: parent
                                   Rectangle{
                                       width: 80
                                       height: 80
                                       Rectangle{
                                           width: 50
                                           height: 50
                                           Image{
                                               anchors.fill: parent
                                               source: "qrc:/assets/Picture/icons/vedio.png"
                                           }
                                       }
                                       FileDialog {
                                           id: fileDialog_video
                                           currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
                                           nameFilters: ["Video files(*)"]
                                           selectedNameFilter.index: 1
                                           onAccepted: {
                                               //设置source添加element
                                               // 获取当前日期和时间
                                               var currentDate = new Date();
                                               // 自定义格式化字符串
                                               var currentFormattedDate = Qt.formatDateTime(currentDate, "yyyy-MM-dd hh:mm:ss");
                                               // sendMessage("sender","Vedio",selectedFile.toString(),currentFormattedDate)
                                           }
                                       }
                                       TapHandler{
                                           onTapped: {
                                               fileDialog_video.open()
                                           }
                                       }
                                   }
                                   Rectangle{
                                       width: 80
                                       height: 80
                                       Rectangle{
                                           width: 50
                                           height: 50
                                           Image{
                                               anchors.fill: parent
                                               source: "qrc:/assets/Picture/icons/vediocall.png"
                                           }
                                       }
                                       TapHandler{

                                       }
                                   }
                                   Rectangle{
                                       id: fileDialog_imageBorder
                                       width: 80
                                       height: 80
                                       Rectangle{
                                           width: 50
                                           height: 50
                                           Image{
                                               anchors.fill: parent
                                               source: "qrc:/assets/Picture/icons/album.png"
                                           }
                                       }
                                       FileDialog {
                                           id: fileDialog_image
                                           currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
                                           nameFilters: ["Image files(*.jpg,*.jpeg,*.png)"]
                                           selectedNameFilter.index: 1
                                           //！！！5.28进度！！！
                                           onAccepted: {
                                               //设置source添加element
                                               // 获取当前日期和时间
                                               var currentDate = new Date();
                                               // 自定义格式化字符串
                                               var currentFormattedDate = Qt.formatDateTime(currentDate, "yyyy-MM-dd hh:mm:ss");
                                               // sendMessage("sender","Picture",selectedFile.toString(),currentFormattedDate)
                                           }
                                       }
                                       TapHandler{
                                           onTapped: {
                                               fileDialog_image.open()
                                           }
                                       }
                                   }
                               }
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

    //bigView
    Rectangle{
        id:imageViewBorder
        z:2
        color: "black"
        width: parent.width
        height: parent.height
        anchors.fill: parent
        visible: false
        Image {
            id:imageViewForMax
            width: parent.width
            height: parent.height
            visible: true
            fillMode: Image.PreserveAspectFit
            TapHandler{
               onTapped: {
                   imageViewBorder.visible=false
                   isFullScreen=false;
               }
            }
        }
    }

    Rectangle {
        z:3
        id:vedioView
        width: parent.width
        height: parent.height
        anchors.fill: parent
        visible: false
        color: "black"
        MediaPlayer {
            id: mediaPlayer_vedioM
            audioOutput: AudioOutput {volume: progressSlider.value}
            videoOutput: vedioOutPut_vedioM
            onMediaStatusChanged: {
                if (status == MediaPlayer.EndOfMedia)
                {
                    console.log("end")
                    mediaPlayer_vedioM.play()
                }
            }
            onPositionChanged: {
                 progressSlider.value = mediaPlayer_vedioM.position / mediaPlayer_vedioM.duration
            }
        }

        VideoOutput {
            id: vedioOutPut_vedioM
            anchors.fill: parent
        }
        Slider {
            id: progressSlider
            visible: false
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 10
            }
            width: parent.width - 20
            value: vedioOutPut_vedioM.position / vedioOutPut_vedioM.duration
            onMoved:  {
                if (vedioOutPut_vedioM.seekable) {
                    mediaPlayer_vedioM.position = progressSlider.value * mediaPlayer_vedioM.duration
                }
            }
        }
        TapHandler {
            onTapped: {
                if (mediaPlayer_vedioM.playing) {
                    // 如果视频正在播放，点击则暂停
                    mediaPlayer_vedioM.pause();
                } else {
                    // 如果视频未播放，点击则开始播放
                    mediaPlayer_vedioM.play();
                }
             }
            onDoubleTapped: {
                mediaPlayer_vedioM.pause();
                vedioView.visible=false;
                progressSlider.visible=false
                isFullScreen=false;
            }
         }
      }
    Component.onCompleted: {
        communicationPage.visible=true
        chatMessageDisplay.visible=true
        inputBox.visible=true
        nickname=communicationPageController.receiverId;
        communicationPageController.onReceiverMessageChanged.connect(onReceiverMessageChangedQml)
        communicationPageController.onSenderMessageChanged.connect(onSenderMessageChangedQml)
        communicationPageController.initCommunicationPage();
    }
    function onReceiverMessageChangedQml(){
        console.log("getReceiverMessage的槽函数")
        var jsonData=JSON.parse(communicationPageController.getReceiverMessage());
        console.log(jsonData.SenderId)
        //添加信息
        var ob={};
        ob.pType = "receiver"
        ob.mType =jsonData.MessageType
        ob.message=jsonData.MessageContent
        ob.time=jsonData.SendTime
        messageListModel.append(ob);
    }

    function onSenderMessageChangedQml(){
        console.log("getSenderMessage的槽函数")
        var jsonData=JSON.parse(communicationPageController.getSenderMessage());
        //添加信息
        var ob={};
        ob.pType = "sender"
        ob.mType =jsonData.MessageType
        ob.message=jsonData.MessageContent
        ob.time=jsonData.SendTime
        messageListModel.append(ob);
    }
}

