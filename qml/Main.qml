import QtQuick
import QtQuick.Controls
import QtQuick.Window 2.2
import QtQuick.Layouts
import UIControl 1.0
import Algorithm 1.0

Item{
    id: main
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight
    visible: true
    // title: qsTr("Hello World")

    readonly property url messagePreviewPage_loader: "MessagePreviewPage.qml"
    readonly property url communicationPage_loader: "CommunicationPage.qml"
    readonly property url contactListPage_loader: "ContactListPage.qml"
    readonly property url addfriendPage_loader: "AddfriendPage.qml"
    readonly property url personalPage_loader: "PersonalPage.qml"
    readonly property url showFriend_loader: "ShowFriendPage.qml"
    readonly property url showStranger_loader: "ShowStrangerPage.qml"

    readonly property url personalinformation_loader: "PersonalInformation"
    //huangruixian-text
    readonly property url main_loader: "Main.qml"

    property string titlecolor: themeColor
    property string themeColor: "#ededed"
    property string titletext: "微信"
    property bool titlevisible: true
    property bool backvisible: false
    property bool pagebar_visible: true
    property alias afController: afController
    // property alias communicationPageController:communicationPageController
    property alias loader: loader

    //hrx-test
    property alias communicationPageLoader: communicationPageLoader
    property int page_num: 3
    property double barheight_rate: 0.05


    signal contactListClicked()

    Component.onCompleted: {
        contactListClicked.connect(afController.onContactListClicked)
    }

    AddFriendPageController{
        id: afController

    }
    // PersonalPageController{
    //     id:personalctrller
    // }

    GetFirstLetter{
        id:getFirstLetter
    }

    // MessagePreviewPageController{
    //     id:messagePriviewPageController
    // }
    // CommunicationPageController{
    //     id:communicationPageController
    // }

    Rectangle{
        id:titlebar
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
                    visible: loader.source === communicationPage_loader ?
                                 true :
                                 (loader.source === personalPage_loader ?
                                      false :
                                      (title_text.visible === true ? false : true))
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
                source:messagePreviewPage_loader
                // onSourceChanged: source === addfriendPage_loader ? afController.initFriendReqs() : source = source


                signal searchTextChanged(var text)

                Component.onCompleted: {
                    addPageClicked.connect(afController.onAddPageClicked)
                    saveToLocal.connect(afController.onSaveToLocal)
                }

                function findPerson(personID){
                    // 1. search from local document
                    // 2. is exist -> return info
                    // 3. not exist -> send find  to server with person(target) id
                    searchTextChanged(personID)
                }

                function addFriend(ID, nickname, avatar_path, gender, area, signal_text, memo){
                    afController.onAddToContacts(ID, nickname, avatar_path, gender, area, signal_text, memo)
                    // 1. add new friend relation to local doucument
                    // var relation;
                    // relation["relation"] = "friend"
                    // relation["ID"] = ID
                    // relation["nickname"] = nickname
                    // relation["avatar_path"] = avatar_path
                    // relation["gender"] = gender
                    // relation["area"] = area
                    // relation["signal_text"] = signal_text
                    // relation["memo"] = memo

                    // fileTools.saveRequest(relation,"relation")

                    console.log("add new friend relation to local doucument")
                }
                onSourceChanged: {
                    if(source===personalinformation_loader)
                    {
                        console.log("source change!!!!!!!!!!!!!!")
                    }
                }
            }
            function updateMessagePreviewPage(){
                loader.source=messagePreviewPage_loader
            }
            Component.onCompleted: {
                messagePreviewPageController.onNewOnlineMessage().connect(updateMessagePreviewPage)

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
                                titlevisible=true
                                titlecolor=themeColor
                                loader.source = messagePreviewPage_loader
                            }
                            if(index === 1){
                                titlevisible=true
                                titlecolor=themeColor
                                loader.source = contactListPage_loader
                            }
                            if(index === 2){
                                personalctrller.initPersonalData()
                                loader.source = personalPage_loader
                                titlevisible=false
                                themeColor="white"
                            }
                            backvisible = false
                            titletext = "微信"
                        }
                    }
                }
            }
        }
    }
 //    Rectangle{
 //        id:initRectangle
 //        anchors.fill: parent
 //        color: "#ededed"
 //        Column{
 //            id:initColumn
 //            anchors.horizontalCenter: parent.horizontalCenter
 //            anchors.verticalCenter: parent.verticalCenter
 //            Rectangle{
 //                id:inputRecid
 //                width: init.width/10*8
 //                height: init.height/10
 //                //color:"#FFAAFF"
 //                Row{
 //                    anchors.horizontalCenter: parent.horizontalCenter
 //                    anchors.verticalCenter: parent.verticalCenter
 //                    id:idrow
 //                    spacing: 25
 //                    Rectangle{
 //                        width: 50
 //                        height: inputRecid.height/2
 //                        // color: "#DEDEDE"
 //                        Text {
 //                            anchors.horizontalCenter: parent.horizontalCenter
 //                            anchors.verticalCenter: parent.verticalCenter
 //                            id: myidtext
 //                            text: qsTr("AcceptId:")
 //                            font.pixelSize: 22
 //                    }
 //                    }
 //                    Rectangle{
 //                        width: inputRecid.width/5*4
 //                        height: inputRecid.height/2
 //                        // color: "#"
 //                        border.color: "black"
 //                        TextInput{
 //                            id:idtextinput
 //                            anchors.fill: parent
 //                            autoScroll: false
 //                            echoMode:TextInput.Normal
 //                            // maximumLength: 10
 //                            font.pixelSize: 22
 //                            horizontalAlignment: TextInput.AlignLeft
 //                            verticalAlignment: TextInput.AlignVCenter
 //                            leftPadding: 10

 //                            validator: RegularExpressionValidator{
 //                                            regularExpression: /\b[1-9]\d{7}\b/
 //                                        }
 //                        }
 //                    }
 //                }
 //            }
 // //----------------------------           ----------------------------------------------------------
 //            Rectangle{
 //                id:inputRecid2
 //                width: init.width/10*8
 //                height: init.height/10
 //                //color:"#FFAAFF"
 //                Row{
 //                    anchors.horizontalCenter: parent.horizontalCenter
 //                    anchors.verticalCenter: parent.verticalCenter
 //                    id:idrow2
 //                    spacing: 25
 //                    Rectangle{
 //                        width: 50
 //                        height: inputRecid2.height/2
 //                        // color: "#DEDEDE"
 //                        Text {
 //                            anchors.horizontalCenter: parent.horizontalCenter
 //                            anchors.verticalCenter: parent.verticalCenter
 //                            id: myidtext2
 //                            text: qsTr("Message:")
 //                            font.pixelSize: 22
 //                    }
 //                    }
 //                    Rectangle{
 //                        width: inputRecid2.width/5*4
 //                        height: inputRecid.height/2
 //                        // color: "#"
 //                        border.color: "black"
 //                        TextInput{
 //                            id:idtextinput2
 //                            anchors.fill: parent
 //                            autoScroll: false
 //                            echoMode:TextInput.Normal
 //                            // maximumLength: 10
 //                            font.pixelSize: 22
 //                            horizontalAlignment: TextInput.AlignLeft
 //                            verticalAlignment: TextInput.AlignVCenter
 //                            leftPadding: 10
 //                            onAccepted: {
 //                                personalctrller.sendmsg=idtextinput2.text
 //                            }
 //                        }
 //                    }
 //                }
 //            }
 //    //--------------------------------------------------------------------
 //            Rectangle{
 //                id:inputRecid3
 //                width: init.width/10*8
 //                height: init.height/10
 //                //color:"#FFAAFF"
 //                Row{
 //                    anchors.horizontalCenter: parent.horizontalCenter
 //                    anchors.verticalCenter: parent.verticalCenter
 //                    id:idrow3
 //                    spacing: 25
 //                    Rectangle{
 //                        width: 50
 //                        height: inputRecid3.height/2
 //                        // color: "#DEDEDE"
 //                        Text {
 //                            anchors.horizontalCenter: parent.horizontalCenter
 //                            anchors.verticalCenter: parent.verticalCenter
 //                            id: myidtext3
 //                            text: qsTr("AcceptMessage:")
 //                            font.pixelSize: 22
 //                    }
 //                    }
 //                    Rectangle{
 //                        width: inputRecid3.width/5*4
 //                        height: inputRecid3.height/2
 //                        // color: "#"
 //                        border.color: "black"
 //                        TextInput{
 //                            id:idtextinput3
 //                            anchors.fill: parent
 //                            autoScroll: false
 //                            echoMode:TextInput.Normal
 //                            // maximumLength: 10
 //                            font.pixelSize: 22
 //                            horizontalAlignment: TextInput.AlignLeft
 //                            verticalAlignment: TextInput.AlignVCenter
 //                            leftPadding: 10
 //                            text: personalctrller.acceptmsg
 //                        }
 //                    }
 //                    Component.onCompleted: {
 //                        personalctrller.acceptmsgChanged.connect(function(msg){
 //                            console.log("signal was touch");
 //                            idtextinput3.text=msg;
 //                        }
 //                            )
 //                    }
 //                }

 //            }
 //    //------------------------------------------------------------------------------
 //            spacing: 10
 //            Rectangle{
 //                id:initbuttonRec
 //                width: init.width/10*8
 //                height: init.height/15
 //                Button{
 //                    anchors.fill: parent
 //                    id:initbutton
 //                    background:Rectangle{
 //                        id:bgRec
 //                        anchors.fill: parent
 //                        color: "#3399FF"
 //                        radius: 5
 //                    }
 //                    onPressed: {
 //                        bgRec.color="#66B2FF"
 //                    }
 //                    onReleased: {
 //                        bgRec.color="#3399FF"
 //                    }

 //                    Text{
 //                        anchors.horizontalCenter: parent.horizontalCenter
 //                        anchors.verticalCenter: parent.verticalCenter
 //                        id:buttontext
 //                        text:qsTr("send")
 //                        font.pixelSize: 25
 //                        color: "white"
 //                    }

 //                    onClicked: {
 //                        personalctrller.acceptid=idtextinput.text
 //                        personalctrller.send()
 //                    }
 //                }
 //            }
 //        }
 //    }

    Loader{
        id:communicationPageLoader
        anchors.fill:parent
        property var temp
    }
}
