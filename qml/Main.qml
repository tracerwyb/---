import QtQuick
import QtQuick.Controls
import QtQuick.Window 2.2
import QtQuick.Layouts
import UIControl 1.0

ApplicationWindow {
    id: main
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    title: qsTr("Hello World")

    readonly property url messagePreviewPage_loader: "MessagePreviewPage.qml"
    readonly property url communicationPage_loader: "CommunicationPage.qml"
    readonly property url contactListPage_loader: "ContactListPage.qml"
    readonly property url addfriendPage_loader: "AddfriendPage.qml"
    readonly property url personalPage_loader: "PersonalPage.qml"
    readonly property url showFriend_loader: "ShowFriendPage.qml"
    readonly property url showStranger_loader: "ShowStrangerPage.qml"

    property string titlecolor: themeColor
    property string themeColor: "#ededed"
    property string titletext: "微信"
    property bool titlevisible: true
    property bool backvisible: false
    property bool pagebar_visible: true
    property alias afController: afController
    property alias loader: loader
    property int page_num: 3
    property double barheight_rate: 0.05

    AddFriendPageController{
        id: afController
    }
    //界面控制
    MessagePreviewPageController{
        id:messagePriviewPageController

    }
    Rectangle{
        z:2
        width: parent.width
        height:parent.height
        color:"#EDEDED"
        Rectangle{
            id: title
            width: main.width
            height: main.height * barheight_rate

            anchors.horizontalCenter: parent.horizontalCenter
            y: 0
            color: titlecolor
            visible: true
            Row{
                width: parent.width
                height: parent.height
                Image{
                    id: back_img
                    height:parent.height / 2.3
                    width: height
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../assets/Picture/icons/back.png"
                    visible: backvisible
                    TapHandler{
                        onTapped: {
                            if(loader.source === addfriendPage_loader || loader.source === showFriend_loader){
                                titletext = "微信"
                                backvisible = false
                                loader.source = contactListPage_loader

                            }
                            if(loader.source === showStranger_loader){
                                loader.source = addfriendPage_loader
                            }
                            if(loader.source === communicationPage_loader){
                                titletext = "微信"
                                loader.source = messagePreviewPage_loader
                            }
                            titlevisible = true
                            pagebar_visible = true
                        }
                    }
                }

                Text{
                    id: title_text
                    width: contentWidth
                    height: parent.height
                    text: qsTr(titletext)
                    font.pixelSize: 18
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter // 水平居中
                    verticalAlignment: Text.AlignVCenter
                    visible: titlevisible
                }

                Image{
                    height:back_img.height
                    width: height
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../assets/Picture/icons/to_personInfo.png"
                    visible: loader.source === communicationPage_loader ? true : (title_text.visible === true ? false : true)
                }
            }
        }
    }

        //Content Area
    Rectangle{
        id: content
        width: main.width
        height: main.height - title.height - pagebar.height
        y: title.height
        border.color: "black"
        Loader {
            id: loader
            anchors.fill: parent
            asynchronous: true
            source:contactListPage_loader
            Component.onCompleted: {
            }
        }
    }

    Rectangle{
        id: pagebar
        width: main.width
        height: main.height * (barheight_rate+0.01)
        anchors.horizontalCenter: main.horizontalCenter
        y: main.height-height
        visible: pagebar_visible
        color: "#ffffff"
        TabBar{
            height: parent.height
            y: 0

            Repeater{
                model: [qsTr("微信"),qsTr("通讯录"),qsTr("我")]
                TabButton{
                    width: text.width
                    height:text.height
                    x: index * width
                    Text{
                        id:text
                        width:pagebar.width / page_num
                        height:pagebar.height
                        text: modelData
                        horizontalAlignment: Text.AlignHCenter // 水平居中
                        verticalAlignment: Text.AlignVCenter
                    }
                    onClicked: {
                        if(index === 0){
                            loader.source = messagePreviewPage_loader
                        }
                        if(index === 1){
                            loader.source = contactListPage_loader
                        }
                        if(index === 2){
                            loader.source = personalPage_loader
                        }
                        backvisible = false
                        titletext = "微信"
                    }
                }
            }
        }
    }

    Loader {
        id: loader2
        anchors.fill: parent
        asynchronous: true
        source:messagePreviewPage_loader
        Component.onCompleted: {
            title.visible=false
            content.visible=false
            pagebar.visible=false
        }
    }
}
