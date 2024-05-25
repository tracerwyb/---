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
    readonly property url addfriendPage_loader: "AddfriendPage.qml"
    readonly property url personalPage_loader: "PersonalPage.qml"

    property alias messagePriviewPageController : messagePriviewPageController
    property int page_num: 3
    property double barheight_rate: 0.07

    Rectangle{
        //显示优先级
        z:2
        id: title
        width: main.width
        height: main.height * barheight_rate

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
    //界面控制

    MessagePreviewPageController{
        id:messagePriviewPageController

    }
    //Content Area
    Rectangle{
        id: content
        width: main.width
        height: main.height - title.height - pagebar.height
        y: title.height
        border.color: "black"
        // Loader {
        //     id: loader
        //     anchors.fill: parent
        //     asynchronous: true
        //     //source:communicationPage_loader
        // }

    }

    Rectangle{
        id: pagebar
        width: main.width
        height: main.height * barheight_rate
        //color: "#ededed"
        anchors.horizontalCenter: main.horizontalCenter
        y: main.height-height
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
