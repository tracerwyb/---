import QtQuick
import QtQuick.Controls
import QtQuick.Window 2.2
import QtQuick.Layouts
import PersonalControl

//import UIControl 1.0

ApplicationWindow {
    id: main

    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    title: qsTr("Hello World")

    readonly property url messagePreviewPage_loader: "MessagePreviewPage.qml"
    readonly property url communicationPage_loader: "CommunicationPage.qml"
    readonly property url contactListPage_loader: "ContactListPage.qml"
    readonly property url personalPage_loader: "Personalpage.qml"


    property int page_num: 3
    property double barheight_rate: 0.07
    PersonalController{
        id:personalctrller

    }

    Rectangle{
        id: title
        width: main.width
        height: main.height * barheight_rate

        anchors.horizontalCenter: parent.horizontalCenter
        y: 0
        color: "#FFFAFF"
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
            // source:addfriendPage_loader
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
                    onClicked: {
                        console.log(index)
                        if(index === 0){
                            loader.source = ""
                        }
                        if(index === 1){
                            loader.source = contactListPage_loader
                        }
                        if(index === 2){
                            personalctrller.initPersonalData();
                            loader.source = personalPage_loader
                        }
                    }
                }
            }
        }
    }

}
