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

    property var titlecolor: "#EDEDED"
    property alias afController: afController
    property alias loader: loader
    property int page_num: 3
    property double barheight_rate: 0.06

    AddFriendPageController{
        id: afController

    }

    Rectangle{
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
            Text{
                width: parent.width
                height: parent.height

                text: qsTr("微信")
                font.pixelSize: 18
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter // 水平居中
                verticalAlignment: Text.AlignVCenter
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
            height: main.height * barheight_rate
            // color: "#E8E8E8"
            anchors.horizontalCenter: main.horizontalCenter
            y: main.height-height
            visible: true

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
                        }
                    }
                }
            }
        }
    }
}
