import QtQuick
import Qt5Compat.GraphicalEffects

Rectangle{
    id: showstranger

    width:parent.width
    height:parent.height

    property string friendID: parent.friendID
    property string signal_text: parent.signal_text_
    property string friend_name: parent.nickname
    property string area: parent.area_
    property string avatar_path: parent.avatar_path_
    property string gender: parent.gender_

    color: "#eeeeee"

    signal sendAddFriRequest(var text)

    Component.onCompleted: {
        sendAddFriRequest.connect(afController.onSendAddFriRequest)
    }

    // show friend base info
    Rectangle{
        id: baseinfo

        width: parent.width
        height: parent.height / 8
        color:"white"
        anchors.leftMargin: 40
        anchors.top: parent.top
        Row{
            width: parent.width
            height: parent.height
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
                id: nickname
                width: parent.width - avatar.width - 30
                height: avatar.height
                anchors.verticalCenter: avatar.verticalCenter
                Column{
                    Text{
                        text: qsTr(friend_name)
                        width: contentWidth + gender.width
                        font.pointSize: 20
                        // anchors.verticalCenter: parent.verticalCenter
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
                        text: qsTr("地区：" + area)
                        font.pointSize: 15

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
        id: memo
        width: parent.width
        height:baseinfo.height / 2
        color:"white"
        anchors.top: baseinfo.bottom
        anchors.bottomMargin: 20
        Text{
            id: memos
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
        height:memo.height / 4
        color: "#eeeeee"
        anchors.top: memo.bottom
    }

    // personal signal
    Rectangle{
        id: sig

        width: parent.width
        height:baseinfo.height / 2
        color:"white"
        anchors.top: gap_1.bottom
        anchors.bottomMargin: 20
        Row{
            width: parent.width
            height: parent.height
            Text{
                id: personal_signal
                text: "个性签名"
                font.pointSize: 16
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 30
            }
            Text{
                id: signal_content
                text: signal_text
                color: "#8a8a8a"
                font.pointSize: 16
                anchors.verticalCenter: parent.verticalCenter
                leftPadding: 30
            }
        }
    }


    Rectangle{
        id: gap_2
        width: parent.width
        height:memo.height / 4.5
        color: "#eeeeee"
        anchors.top: sig.bottom
    }

    // add friend button
    Rectangle{
        id: add_to

        width: parent.width
        height:baseinfo.height / 2
        anchors.top: gap_2.bottom
        color:"white"
        Text{
            id: add_but
            text: "添加到通讯录"
            font.pointSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            // leftPadding: 30
        }
        TapHandler{
            onTapped:{
                sendAddFriRequest(search_content.text)
            }
        }
    }
}
