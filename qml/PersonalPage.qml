import QtQuick
import QtQuick.Window
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Rectangle{
    property string u_name: personalctrller.netname//"aLIEz"
    property string u_number:personalctrller.netnumber// "1234"
    id:mine
    width: parent.width//Screen.desktopAvailableWidth
    height:parent.height//Screen.desktopAvailableHeight
    visible: true
    color: "#FFFAFF"

    Rectangle{
        id:re
        width: parent.width
        height: parent.height/4
        color:"white"

        TapHandler{
            id:avatertaphandler
            onTapped:{
                loader.source="PersonalInformation.qml"
                titlevisible=true
                themeColor="#ededed"
                titletext="个人信息"
                console.log("avater was clicked:"+titletext)
                personalctrller.sendImage();
            }

        }
        // Rectangle{
        //     width: 400
        //     height: 400
        //     color: "blue"
        //     Image {
        //         id: test
        //         anchors.fill: parent
        //         source: "image://pi/1"
        //     }
        // }

        Rectangle{

            id:avatar;
            width: parent.height/3
            height: parent.height/3
            x:parent.width/20
            y:parent.height/3
            radius: 10
            color: "transparent"
            clip: true
            Image {
                id: avator1
                // anchors.fill: parent
                width: parent.width
                height: parent.height
                // sourceSize: Qt.size(parent.width,parent.height)   //让图片能够平滑的显示
                // source: "qrc:/assets/Picture/avatar/avater1.jpg"
                source: "image://pictures/avater"
                fillMode: Image.PreserveAspectCrop
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
                anchors.fill: avator1
                source: avator1
                maskSource: maskrec
            }
        }

        Text {
            id: username
            text: qsTr(u_name)
            font.pixelSize: 25
            anchors.left: avatar.right
            anchors.top:avatar.top
            anchors.leftMargin: avatar.width/5
            anchors.topMargin: 2
        }
        Text {
            id: usernumber
            text: qsTr("微信号:"+u_number)
            anchors.bottom: avatar.bottom
            anchors.left: avatar.right
            anchors.bottomMargin: 5
            anchors.leftMargin: avatar.width/5

        }
    }
//---------------------------------------------------------------------------------
    Rectangle{
        id:serve
        width: parent.width
        height: parent.height/15
        anchors.top: re.bottom
        anchors.topMargin: 30
        // Button{
        //     anchors.fill: parent
        //     flat: true                        //设置为扁平按钮
        // }

        Image {
            id: serveimge1
            anchors.left: serve.left
            anchors.rightMargin: serve.width/16
            //anchors.top:serve.top
            //anchors.topMargin: serve.height*2/9
            sourceSize: Qt.size(serve.width,serve.height)
            source: "qrc:/assets/Picture/icons/serve.jpg"
        }
        Text {
            id: servetext
            text: qsTr("服务")
            font.pixelSize: 18
            anchors.left: serveimge1.right
            //anchors.leftMargin: serve.width/14
            anchors.top: serve.top
            anchors.topMargin:serve.height/3
        }
        Image {
            id: serveimge2
            anchors.right: serve.right
            anchors.rightMargin: serve.width/16
            anchors.top:serve.top
            anchors.topMargin: serve.height*2/9
            sourceSize: Qt.size(serve.width,serve.height)
            source: "qrc:/assets/Picture/icons/jiantou.png"
        }
    }

// - - - - - - - - - - - -- - - - - - - - - - - - --------------------------------------
    Rectangle{
        id:list
        width: parent.width
        height: mine.height/15*4           //
        anchors.top: serve.bottom
        anchors.topMargin: 10
        ListModel {
            id: listModel

            ListElement {
                name: "收藏"
            }
            ListElement {
                name: "朋友圈"
            }
            ListElement {
                name: "卡包"
            }
            ListElement{
                name: "表情"
            }
        }


        Component {
            id: listDelegate
            Rectangle{
                id:itemrec
                width: mine.width
                height: mine.height/15
                color: "white"//"#F5F5DC"
                border.color: "#DCDCDC"
                TapHandler{
                    id:itemrectaphandler
                    onTapped: {
                        console.log("list was clicked")
                        listenThread.stopThread();
                    }
                }
                Image {
                    id:imgedelegate
                    anchors.left: itemrec.left
                    anchors.rightMargin: itemrec.width/16
                    //anchors.top:serve.top
                    //anchors.topMargin: serve.height*2/9
                    sourceSize: Qt.size(serve.width,serve.height)
                    source: "qrc:/assets/Picture/icons/"+name+".jpg"
                }
                Text {
                    text: name
                    font.pixelSize: 18
                    anchors.left: imgedelegate.right
                    //anchors.leftMargin: itemrec.width/14
                    anchors.top:itemrec.top
                    anchors.topMargin: itemrec.height/3
                }
                Image {
                    id: arrowhead
                    anchors.right: itemrec.right
                    anchors.rightMargin: itemrec.width/16
                    anchors.top:itemrec.top
                    anchors.topMargin: itemrec.height*2/9
                    sourceSize: Qt.size(itemrec.width,itemrec.height)
                    source: "qrc:/assets/Picture/icons/jiantou.png"
                }

            }
        }
        ListView {
            anchors.fill: parent
            model: listModel
            delegate: listDelegate
        }

    }
//-----------------------------------------------------------------------------
    Rectangle{
        id:setup
        width: parent.width
        height: parent.height/15
        anchors.top: list.bottom
        anchors.topMargin: 10
        TapHandler{
            id:setuptaphandler
            onTapped: {
                console.log("setup was clicked!")
                pup.open()
            }
        }
        Image {
            id:setupimage1
            anchors.left: setup.left
            anchors.rightMargin: setup.width/16
            //anchors.top:serve.top
            //anchors.topMargin: serve.height*2/9
            sourceSize: Qt.size(serve.width,serve.height)
            source: "qrc:/assets/Picture/icons/"+"设置.jpg"
        }
        Text {
            id: setuptext
            text: qsTr("设置")
            font.pixelSize: 18
            anchors.left: setupimage1.right
            //anchors.leftMargin: setup.width/14
            anchors.top: setup.top
            anchors.topMargin:setup.height/3
        }
        Image {
            id: setupimage
            anchors.right: setup.right
            anchors.rightMargin: setup.width/16
            anchors.top:setup.top
            anchors.topMargin: setup.height*2/9
            sourceSize: Qt.size(setup.width,setup.height)
            source: "qrc:/assets/Picture/icons/jiantou.png"        }
    }
  //-----------------------------------------------------------------------------
    Popup{
        id:pup
        width: parent.width
        height: 200
        background: Rectangle{
            color: Qt.rgba(255,255,255)
            radius: 10
            clip: true
        }
        x:0
        y:main.height-pup.height
        modal: true
        padding: 0
        onClosed: console.log("pup was closed")
        Rectangle{
            id:poprec
            anchors.fill: parent
            radius: 10
            clip: true
            ListModel{
                id:exitlist
                ListElement{
                    name:"退出登录"
                }
                ListElement{
                    name:"关闭微信"
                }
                ListElement{
                    name:"取消"
                }
            }
            Component{
                id:exitcomponent
                Rectangle{
                    id:listrec
                    width: poprec.width
                    height: poprec.height/4
                    Button{
                        id:buttonitem
                        anchors.fill: parent
                        background: Rectangle{
                            id:buttonrec
                            color:"white"
                            border.color: "#e9eded"
                        }

                        onPressed: {
                            buttonrec.color="#ededed"
                        }
                        onReleased: {
                            buttonrec.color="white"
                            if(index===0){                         //退出登录回到重新输入id的初始化界面
                                console.log("1 was clicked")
                                pup.close()
                                initRectangle.visible=true
                                idtextinput.text=""
                                initloader.source=""
                                // loader.source=messagePreviewPage_loader

                            }
                            else if(index===1){                 //关闭微信
                                console.log("2 was clicked")
                                pup.close()
                                Qt.quit()
                            }
                            else{                               //取消
                                console.log("3 was clicked")
                                pup.close()
                            }
                        }
                        Text {
                            id: poprectext
                            text: name
                            font.pixelSize: 18
                            anchors.centerIn: parent
                        }

                    }
                }
            }
            ListView{
                anchors.fill: parent
                model: exitlist
                delegate: exitcomponent
            }
        }
    }


}

