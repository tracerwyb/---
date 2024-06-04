import QtQuick
import QtQuick.Shapes 1.7

Rectangle {
    id:contactsPage

    width: parent.width
    height: parent.height

    property bool isContactsUpdate: false

    readonly property url addfriendPage_loader: "AddfriendPage.qml"
    // readonly property url groupList_loader: "AddfriendPage.qml"
    // readonly property url label_loader: "AddfriendPage.qml"

    Component.onCompleted: {
        if(isContactsUpdate){
            readFriendFromLocal()
            isContactsUpdate = false
        }
        console.log("contact list page")
        if(loader.source===contactListPage_loader){
            afController.initFriendList()
        }
    }

    function readFriendFromLocal(){
        // 1. read all friend from local document(friend state === 1)
        // 2. add friend model to name_model
        // 3. 去重**
    }

    Connections{
        target: afController

        function onSendAcceptSignal(text){
            fileTools.modifyRelation(JSON.parse(text),"friend")
        }

        function onInitfrilist(text){
            if(text !== "")
            var tmp = JSON.parse(text)
            console.log("init friend list 111111111111111111111111")
            console.log(tmp["ID"])
            // name_model.append({ID:tmp["ID"],
            //                       name:tmp["nickname"],
            //                       memo:tmp["nickname"],
            //                       frist_letter:"A",
            //                       area:tmp["area"],
            //                       signal_text:tmp["signal_text"],
            //                       avatar_path:"../assets/Picture/icons/newfriend.png",
            //                       gender:tmp["gender"]
            //                   })
            // name_model.append(   {ID:"20000002" ,
            //                       name: "Bob" ,
            //                       memo: "Bob",                                  first_letter: "A",
            //                       area: "中国大陆 重庆",
            //                       signal_text: "测试： 个性签名 Bob",
            //                       avatar_path: "../assets/Picture/icons/newfriend.png" ,
            //                       gender: "女"})
            var ob={}
            ob.ID=tmp.ID
            ob.name=tmp.nickname
            ob.memo=tmp.nickname
            ob.first_letter="A"
            ob.area=tmp.area
            ob.signal_text=tmp.signal_text
            ob.avatar_path="../assets/Picture/icons/newfriend.png"
            ob.gender=tmp.gender
            name_model.append(ob)
        }

    }


    // top
    ListModel {
        id: contacts_model

        ListElement { name: "新的朋友"; avatar_path: "../assets/Picture/icons/newfriend.png";}
        ListElement { name: "群聊"; avatar_path: "../assets/Picture/icons/group_people.png";}
        ListElement { name: "标签"; avatar_path: "../assets/Picture/icons/label.png";}
    }

    Component {
        id: contacts_delegate

        Row {
            id: row
            spacing: 10
            padding: 10
            Image {
                id: icon
                width: contactsPage.width / 11
                height: width
                source: avatar_path
                fillMode: Image.PreserveAspectFit
            }
            Rectangle{
                id: rect
                width: contactsPage.width - icon.width - row.spacing - row.padding*2
                height: icon.height
                // border.color: "#E8E8E8"

                // Rectangle{
                //     anchors{
                //         fill: rect;
                //         bottomMargin:rect.border.width;
                //     }
                // }
                Text {
                    id:text
                    font.pixelSize: 14
                    text: name
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            TapHandler{
                onTapped: {
                    if(model.name === "新的朋友"){
                        // console.log(model.name)
                        // loader 动态加载页面 AddfriendPage
                        loader.source = addfriendPage_loader

                        titletext = "新的朋友"
                        pagebar_visible = false
                        backvisible = true
                    }
                    if(model.name === "群聊"){
                        // console.log(model.name)
                    }
                    if(model.name === "标签"){
                        // console.log(model.name)
                    }
                }
            }
        }
    }

    ListModel {
        id: name_model
        ListElement {
            ID:"20000001" ;
            name: "Alice" ;
            memo: "Alice";
            first_letter: "A";
            area: "中国大陆 重庆";
            signal_text: "测试： 个性签名 Alice";
            avatar_path: "../assets/Picture/icons/newfriend.png" ;
            gender: "女"
        }
        // ListElement {
        //     ID:"20000002" ;
        //     name: "Bob" ;
        //     memo: "Bob";
        //     first_letter: "A";
        //     area: "中国大陆 重庆";
        //     signal_text: "测试： 个性签名 Bob";
        //     avatar_path: "../assets/Picture/icons/newfriend.png" ;
        //     gender: "女"
        // }
        // ListElement {
        //     ID:"20000003" ;
        //     name: "Carol" ;
        //     memo: "Carol";
        //     first_letter: "A";
        //     area: "中国大陆 重庆"
        //     signal_text: "测试： 个性签名 Bob";
        //     avatar_path: "../assets/Picture/icons/newfriend.png" ;
        //     gender: "男"
        // }
        // ListElement {
        //     ID:"20000004" ;
        //     name: "David" ;
        //     memo: "David";
        //     first_letter: "D";
        //     signal_text: "测试： 个性签名 Bob";
        //     avatar_path: "../assets/Picture/icons/newfriend.png" ;
        //     area: "中国大陆 重庆"
        //     gender: "男"
        // }
        // ListElement {
        //     ID:"20000005" ;
        //     name: "Ella" ;
        //     memo: "Ella";
        //     first_letter: "E";
        //     area: "中国大陆 重庆"
        //     signal_text: "测试： 个性签名 Bob";
        //     avatar_path: "../assets/Picture/icons/newfriend.png" ;
        //     gender: "女"
        // }
        // ListElement {
        //     ID:"20000006" ;
        //     name: "Flla" ;
        //     memo: "Flla";
        //     first_letter: "F";
        //     area: "中国大陆 重庆"
        //     signal_text: "测试： 个性签名 Bob";
        //     avatar_path: "../assets/Picture/icons/newfriend.png" ;
        //     gender: "女"
        // }
        // ListElement {
        //     ID:"20000007" ;
        //     name: "Alice" ;
        //     memo: "Alice";
        //     first_letter: "G";
        //     area: "中国大陆 重庆"
        //     signal_text: "测试： 个性签名 Bob";
        //     avatar_path: "../assets/Picture/icons/newfriend.png" ;
        //     gender: "女"
        // }
        // 添加更多姓名，以字母顺序排列
    }

    Rectangle{
        width: top.width
        height: top.height
        color: "white"
        z:1
        ListView {
            id: top
            interactive: false              // forbid drag operation
            width: contactsPage.width
            height:180
            model: contacts_model
            delegate: contacts_delegate
        }
    }



    ListView {

        y: top.height
        width: parent.width
        height:parent.height - top.height
        model: 26 // A-Z 字母的数量
        delegate: Item {
            id:parentItem
            width: contactsPage.width
            height: childrenRect.height === 19 ? 0 : childrenRect.height
            visible: height === 0 ? false : true

            Component.onCompleted: console.log(height)
            property string letter: String.fromCharCode(index + 65) // A-Z 字母
            property var filteredNames: []

            Column {
                spacing: 5
                Text {
                    id:alb
                    text: letter
                    font.bold: true
                    x:20
                }
                ListView {
                    id: user

                    width: contactsPage.width
                    height: contentHeight
                    model: name_model

                    delegate:Row{
                        id: user_row
                        height: model.first_letter === parentItem.letter ? 55 : 0

                        property var friend_ID : model.ID
                        property var nick_name : model.name
                        property var me_mo_ : model.memo
                        property var signal_t : model.signal_text
                        property var ara : model.area
                        property var ava_ : model.avatar_path

                        Rectangle{width: 10; height:model.first_letter === parentItem.letter ? avatar.height+20 : 0}
                        Image{
                            id: avatar
                            width: contactsPage.width / 11
                            height: width
                            source: model.first_letter === parentItem.letter ? model.avatar_path : ""
                            fillMode: Image.PreserveAspectFit
                        }
                        Rectangle{width: 10; height:0.0001}
                        Rectangle{
                            id: rect
                            width: user.width - 20 - avatar.width
                            height: avatar.height
                            // Rectangle{
                            //     width: parent.width
                            //     height: 0.6
                            //     border.width: 0.6
                            //     anchors.bottom:parent.bottom
                            // }
                            Text {
                                text: model.first_letter === parentItem.letter ? model.name : ""
                                font.italic: true
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        // TapHandler{
                        //     onTapped: console.log("ontapped")
                        // }
                        TapHandler{
                            onTapped:{

                                if(model.ID !== ""){

                                    friendID = friend_ID
                                    nickname = nick_name
                                    memo_ = me_mo_
                                    signal_text_ = signal_t
                                    area_ = ara
                                    avatar_path_ = ava_

                                    backvisible = true
                                    titlevisible = false
                                    pagebar_visible = false
                                    loader.source = showFriend_loader
                                }

                            }
                        }

                    }


                }
            }


        }
    }
}

