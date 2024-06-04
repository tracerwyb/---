import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id:personalInformationpage
    width:parent.width
    height:parent.height
    property string u_name: personalctrller.netname//"aLIEz"
    property string u_number:personalctrller.netnumber// "1234"
    Rectangle{
        id:perimfrec
        anchors.fill: parent
        color: "#FFFAFF"

        Rectangle{
            id:avater
            width: parent.width
            height: perimfrec.height/10
            color: "white"
            anchors.top: perimfrec.top
            anchors.left: perimfrec.left
            Text {
                id: avatertext
                text: qsTr("头像")
                font.pixelSize: 18
                anchors.left: avater.left
                anchors.leftMargin: 10
                anchors.top: avater.top
                anchors.topMargin: avater.height/3
            }
            Image {
                id: arrowhead
                anchors.right: avater.right
                anchors.rightMargin: avater.width/25
                anchors.top:avater.top
                anchors.topMargin: avater.height*2/9
                sourceSize: Qt.size(avater.width,avater.height)
                source: "qrc:/assets/Picture/icons/jiantou.png"
            }
            Rectangle{
                id:avaterrce
                width: parent.height/5*4
                height: parent.height/5*4
                anchors.right: arrowhead.left
                anchors.top:avater.top
                anchors.topMargin: avater.height/9
                Image{
                    id:avaterimage
                    sourceSize: Qt.size(avater.width,avater.height)
                    // source: "qrc:/assets/Picture/avatar/avater2"            //
                    source: "image://pictures/avater"
                    visible: false
                }
                Rectangle{
                    id:maskrec
                    radius: 10
                    anchors.fill: parent
                    //color: "white"     //这里有点奇怪，如果设置mask的矩形颜色为transparent,那么图片显示不出来，如果设为其他颜色或者注释掉图片能够正常显示
                    visible: false
                }
                OpacityMask{
                    anchors.fill: avaterrce
                    source: avaterimage
                    maskSource: maskrec
                }
            }



        }
//------------------------------------------------------------------------------
        Rectangle{
            id:list
            width: parent.width
            height: perimfrec.height/15*4          //
            anchors.top: avater.bottom
            ListModel {
                id: listModel

                ListElement {
                    name: "名字"
                }
                ListElement {
                    name: "拍一拍"
                }
                ListElement{
                    name: "微信号"
                }
                ListElement{
                    name: "二维码名片"
                }

            }


            Component {
                id: listDelegate
                Rectangle{
                    id:itemrec
                    width: perimfrec.width
                    height: perimfrec.height/15
                    color: "white"//"#F5F5DC"
                    border.color: "#DCDCDC"
                    Text {
                        text: name
                        font.pixelSize: 18
                        anchors.left: itemrec.left
                        anchors.leftMargin: 10
                        anchors.top:itemrec.top
                        anchors.topMargin: itemrec.height/3
                    }
                    Image {
                        id: arrowhead
                        anchors.right: itemrec.right
                        anchors.rightMargin: itemrec.width/25
                        anchors.top:itemrec.top
                        anchors.topMargin: itemrec.height*2/9
                        sourceSize: Qt.size(itemrec.width,itemrec.height)
                        source: "qrc:/assets/Picture/icons/jiantou.png"
                    }

                    Text {
                        id: context
                        text: {
                            if(index === 0){
                                text=u_name
                            }
                            if(index === 2){
                                text=u_number
                            }
                        }
                        font.pixelSize: 18
                        anchors.right: arrowhead.left
                        anchors.top:itemrec.top
                        anchors.topMargin: itemrec.height/3
                    }

                }
            }
            ListView {
                anchors.fill: parent
                model: listModel
                delegate: listDelegate
            }

        }
//------------------------------------------------------------------------------------------------
        Rectangle{
            id:sound
            width: parent.width
            height: parent.height/15
            anchors.top: list.bottom
            anchors.topMargin: 10

            Text {
                id: soundtext
                text: qsTr("来电铃声")
                font.pixelSize: 18
                anchors.left: sound.left
                anchors.leftMargin: 10
                anchors.top: sound.top
                anchors.topMargin:sound.height/3
            }
            Image {
                id: soundimage
                anchors.right: sound.right
                anchors.rightMargin: sound.width/25
                anchors.top:sound.top
                anchors.topMargin: setup.height*2/9
                sourceSize: Qt.size(sound.width,sound.height)
                source: "qrc:/assets/Picture/icons/jiantou.png"
            }
        }

        Rectangle{
            id:wechatbean
            width: parent.width
            height: parent.height/15
            anchors.top: sound.bottom
            anchors.topMargin: 10

            Text {
                id: wechatbeantext
                text: qsTr("微信豆")
                font.pixelSize: 18
                anchors.left: wechatbean.left
                anchors.leftMargin: 10
                anchors.top: wechatbean.top
                anchors.topMargin:wechatbean.height/3
            }
            Image {
                id: wechatbeanimage
                anchors.right: wechatbean.right
                anchors.rightMargin: wechatbean.width/25
                anchors.top:wechatbean.top
                anchors.topMargin: wechatbean.height*2/9
                sourceSize: Qt.size(wechatbean.width,wechatbean.height)
                source: "qrc:/assets/Picture/icons/jiantou.png"
            }
        }
        Rectangle{
            id:myaddress
            width: parent.width
            height: parent.height/15
            anchors.top: wechatbean.bottom
            anchors.topMargin: 10
            Text {
                id: myaddresstext
                text: qsTr("微信豆")
                font.pixelSize: 18
                anchors.left: myaddress.left
                anchors.leftMargin: 10
                anchors.top: myaddress.top
                anchors.topMargin:myaddress.height/3
            }
            Image {
                id: myaddressimage
                anchors.right: myaddress.right
                anchors.rightMargin: myaddress.width/25
                anchors.top:myaddress.top
                anchors.topMargin: myaddress.height*2/9
                sourceSize: Qt.size(myaddress.width,myaddress.height)
                source: "qrc:/assets/Picture/icons/jiantou.png"
            }
        }
    }
}
