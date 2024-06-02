import QtQuick
import Qt5Compat.GraphicalEffects

Rectangle{
    id: showfriend

    width:parent.width
    height:parent.height

    property string friendID: parent.friendID /* "2000000"*/
    property string nickname: parent.nickname /*"85"*/
    property string memo: parent.memo_ /*"85"*/
    property string signal_text: parent.signal_text_ /*"罪业的报偿"*/
    property string area: parent.area_ /*"中国大陆 重庆"*/
    property string avatar_path: parent.avatar_path_ /*"../assets/Picture/avatar/cats.jpg"*/
    property string gender: parent.gender_

    color: "#eeeeee"

    // show friend base info
    Rectangle{
        id: baseinfo

        width: parent.width
        height: parent.height / 6.5
        color:"white"
        anchors.leftMargin: 40
        anchors.top: parent.top
        Row{
            width: parent.width
            height: parent.height / 1.3
            spacing: 20

            // placeholder: left margin of avatar
            Rectangle{
                width: 1
                height: 1
            }

            Rectangle{
                id: avatar
                width: parent.height / 1.5
                height: width
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: image
                    width: parent.height
                    height: width
                    fillMode: Image.PreserveAspectFit
                    visible: false
                    source: avatar_path
                }
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
                    visible: false;
                }
                OpacityMask {
                    id: avatar_mask
                    anchors.fill: image
                    source: image
                    maskSource: maskRec
                }
            }

            Rectangle{
                id: show_nickname
                width: parent.width - avatar.width - 30
                height: avatar.height
                anchors.verticalCenter: avatar.verticalCenter
                Column{
                    Text{
                        text: qsTr(memo)
                        width: contentWidth + gender.width
                        font.pointSize: 20
                        Image{
                            id: gender
                            anchors.right: parent.right
                            height: parent.height
                            width: height
                            fillMode: Image.PreserveAspectFit
                            source: "../assets/Picture/icons/compass-black.png"
                        }
                    }
                    Text {
                        text: qsTr("昵称：" + nickname)
                        font.pointSize: 13
                        color: "#8a8a8a"
                    }
                    Text {
                        text: qsTr("ID：" + friendID)
                        font.pointSize: 13
                        color: "#8a8a8a"
                    }
                    Text {
                        text: qsTr("地区：" + area)
                        font.pointSize: 13
                        color: "#8a8a8a"
                    }
                }
            }
        }
        Rectangle{
            width: parent.width * 0.9
            height: 0.6
            border.color: "#c7c7c7"
            border.width: 0.6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:parent.bottom
        }

    }

    // set memos
    Rectangle{
        id: showmemo
        width: parent.width
        height:baseinfo.height / 2.5
        color:"white"
        anchors.top: baseinfo.bottom
        anchors.bottomMargin: 20
        Text{
            id: memo_text
            text: "设置备注"
            font.pointSize: 16
            anchors.verticalCenter: parent.verticalCenter
            leftPadding: 30
        }
        Image {
            id: goahead_img
            width: parent.height / 3
            height: width
            fillMode: Image.PreserveAspectFit
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 20
            source: "../assets/Picture/icons/go_ahead.jpg"
        }
        TapHandler{
            onTapped: {
                console.log("imcompleted function")
            }
        }
    }

    Rectangle{
        id: gap_1
        width: parent.width
        height:showmemo.height / 4
        color: "#eeeeee"
        anchors.top: showmemo.bottom
    }

    // friend circle
    Rectangle{
        id: friend_circle

        width: parent.width
        height:showmemo.height
        color:"white"
        anchors.top: gap_1.bottom
        anchors.bottomMargin: 20
        Row{
            width: parent.width
            height: parent.height
            Text{
                id: circle_text
                text: "朋友圈"
                font.pointSize: 16
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 30
            }
            Image {
                id: circle_img
                width: parent.height / 3
                height: width
                fillMode: Image.PreserveAspectFit
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 20
                source: "../assets/Picture/icons/go_ahead.jpg"
            }
            TapHandler{
                onTapped: {
                    console.log("imcompleted function")
                }
            }
        }
        Rectangle{
            width: parent.width * 0.9
            height: 0.6
            border.color: "#c7c7c7"
            border.width: 0.6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:parent.bottom
        }
    }

    // more infomation: 个性签名，来源
    Rectangle{
        id: more

        width: parent.width
        height:showmemo.height
        color:"white"
        anchors.top: friend_circle.bottom
        anchors.bottomMargin: 20
        Row{
            width: parent.width
            height: parent.height
            Text{
                id: more_text
                text: "更多信息"
                font.pointSize: 16
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 30
            }
            Image {
                id: more_img
                width: parent.height / 3
                height: width
                fillMode: Image.PreserveAspectFit
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 20
                source: "../assets/Picture/icons/go_ahead.jpg"
            }
            TapHandler{
                onTapped: {
                    console.log("imcompleted function")
                }
            }
        }
    }


    Rectangle{
        id: gap_2
        width: parent.width
        height:showmemo.height / 4.5
        color: "#eeeeee"
        anchors.top: more.bottom
    }

    // change to send message page
    Rectangle{
        id: send_msg

        width: parent.width
        height:showmemo.height
        anchors.top: gap_2.bottom
        color:"white"
        Text{
            id: sendmsg_text
            text: "发消息"
            font.pointSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
        Rectangle{
            width: parent.width
            height: 0.6
            border.color: "#c7c7c7"
            border.width: 0.6
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom:parent.bottom
        }
        TapHandler{
            onTapped:{
                // load send message page
                loader.source = communicationPage_loader
            }
        }
    }

    // audio/video chat
    Rectangle{
        id: av_chat

        width: parent.width
        height:showmemo.height
        anchors.top: send_msg.bottom
        color:"white"
        Text{
            id: avchat_msg
            text: "音视频通话"
            font.pointSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            // leftPadding: 30
        }
        TapHandler{
            onTapped:{
                // choose to video or audio(pop a alternative rectangle)

                // calling
            }
        }
    }
}
