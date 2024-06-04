import QtQuick
import Qt5Compat.GraphicalEffects

Rectangle {
    id: newfriend
    width: parent.width
    height: parent.height
    color: "#eeeeee"

    property bool loaderVisible : false
    property bool newfriV: true
    property int isfriend
    property bool isContactsUpdate: true

    signal saveToLocal(var text,var file)
    Component.onCompleted: {
        searchTextChanged.connect(afController.onSearchTextChanged)
        if(loader.source===addfriendPage_loader){
            afController.initFriendReqs()
        }
    }

    // friend base info page loader
    Loader{
        id: loader_stranger
        asynchronous: true
        anchors.fill: parent
        // source: showFriend_loader
        // source: showStranger_loader
        // visible: loaderVisible

        property string friendID
        property string nickname
        property string memo_
        property string signal_text_
        property string area_
        property string avatar_path_
        property string gender_

        function setProperties(text){
            if(text !== ""){
                var tmp = JSON.parse(text)

                // 2. set value of person page infomation
                friendID     = tmp["friendID"]
                nickname     = tmp["nickname"]
                avatar_path_ = tmp["avatar_path_"]
                gender_      = tmp["gender"]
                area_        = tmp["area"]
                signal_text_ = tmp["signature"]
                memo_        = tmp["memo"]
            }

        }

        Connections{
            target: afController
            function onFriendBaseInfo(text){
                console.log("on friend base info called")
                loader_stranger.setProperties(text)
                var tmp = JSON.parse(text)
                if(isfriend === 0){
                    tmp["relation"] = "stranger"
                }else{
                    tmp["relation"] = "friend"
                }

                saveToLocal(JSON.stringify(tmp),"relation")
            }

            function onIsFriendSignal(text){
                var tmp = JSON.parse(text)
                isfriend =(tmp["isfriend"] === "true" ? 1 : 0)
                console.log("isfriend:" + tmp["isfriend"])
            }

            function onInitFriReq(text){
                console.log("on init friend page received called")
                var tmp = JSON.parse(text)
                addreq_model.append( {ID:tmp["myid"],
                                    nickname:tmp["my_nickname"],
                                    fristletter:"A",
                                    avatar:tmp["my_avatar"],
                                    gender:tmp["gender"],
                                    area:tmp["area"],
                                    signal_text:tmp["signature"],
                                    memo:tmp["my_avatar"]})
            }
        }

    }

    // 搜索栏
    Rectangle
    {
        id:searchBar
        y: parent.height * 0.02
        z: 1
        anchors.horizontalCenter: parent.horizontalCenter
        width:newfriend.width * 0.9
        height: newfriend.height / 18
        border.color: "#e8e8e8"
        border.width: 1
        radius: searchBar.height / 4
        visible: newfriV
        //信号

        TextInput {
            id: search_content

            anchors.leftMargin: 20
            anchors.left: parent.left
            anchors.right: image_search.left
            anchors.rightMargin: 15
            height: parent.height
            font.pointSize: 15
            color: "Black"
            y:0
            maximumLength: 30
            focus: true
            wrapMode: Text.WordWrap
            verticalAlignment: TextInput.AlignVCenter
            validator: RegularExpressionValidator{
                regularExpression: /\b[1-9]\d{7}\b/
            }
            // focus: true
        }

        Image {
            id: image_search
            width: 20
            height:20
            x:10
            anchors.right: searchTxt.left
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit

            source: "../assets/Picture/icons/find.png"
            TapHandler{
                id: searchButton_img
                onTapped: {
                    findPerson(search_content.text)
                    newfriV = false

                    titlecolor = "#ffffff"
                    loaderVisible = true
                }
            }
        }

        Text {
            id: searchTxt
            text: qsTr("搜索")
            anchors.verticalCenter: parent.verticalCenter
            // anchors.left:image_search.right
            anchors.right: parent.right
            anchors.leftMargin: 2
            anchors.rightMargin: 20
            font.pointSize: 14
            font.bold: true
            TapHandler{
                id: searchButton_text
                onTapped: {
                    findPerson(search_content.text)

                    if(isfriend === 1){
                        loader_stranger.source = showFriend_loader
                    }else{
                        loader_stranger.source = showStranger_loader
                    }

                    titlecolor = "#ffffff"
                    // loaderVisible = true
                    titlevisible = false
                    newfriV = false
                    search_content.focus = false
                }
            }
        }
    }

    ListView{
        id: addreq
        width: parent.width
        height: parent.height - searchBar.height - searchBar.y - gap.height
        model:addreq_model
        delegate: addreq_delegate
        visible: newfriV
        anchors.top: gap.bottom
    }

    Rectangle{
        id: gap
        width: parent.width
        height:searchBar.height / 4
        color: "#eeeeee"
        visible: newfriV
        anchors.top: searchBar.bottom
    }

    ListModel{
        id: addreq_model
        ListElement{
            ID:00000000;
            nickname:"测试";
            fristletter:"a";
            avatar:"../assets/Picture/avatar/cats.jpg";
            who:"hhh";
            gender:"女"
            area:"China";
            signal_text:"这个人什么都没有写";
            memo:"test_memo";
        }
    }

    Component{
        id: addreq_delegate

        Rectangle{
            id: addreq_rec
            width: newfriend.width
            height: searchBar.height * 1.5
            property int addreqID: model.ID
            property var addreqNick: model.nickname
            property var addreqAvatar: model.avatar
            property var addreqGender: model.gender
            property var addreqArea: model.area
            property var addreqSig: model.signal_text
            property var addreqMemo: model.memo
            Row{
                spacing: 20
                anchors.verticalCenter: parent.verticalCenter

                Rectangle{
                    width: 1
                    height: 1
                }

                Rectangle{
                    id: avatar
                    width: addreq_rec.height / 1.25
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                    Image {
                        id: image
                        width: parent.height
                        height: width
                        fillMode: Image.PreserveAspectFit
                        visible: false
                        source: model.avatar
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
                    width: addreq_rec.width - avatar.width - 30
                    height: avatar.height * 0.8
                    anchors.verticalCenter: avatar.verticalCenter
                    Text {
                        id:t1
                        text: qsTr(model.nickname)
                        font.pointSize: 15
                    }
                    Text {
                        text: qsTr(model.who)
                        font.pointSize: 12
                        color: "#8a8a8a"
                        anchors.top: t1.bottom
                    }
                    Rectangle{
                        id: accept_but
                        width:parent.width / 5.5
                        height: parent.height / 1.3
                        radius: 10
                        anchors.right: parent.right
                        anchors.rightMargin: 40
                        anchors.verticalCenter: parent.verticalCenter
                        border.color: "#eeeeee"
                        Text{
                            text: qsTr("接受")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        TapHandler{
                            onTapped: {
                                console.log("accept button on clicked")
                                console.log(model.ID)
                                console.log(model.nickname)
                                console.log(model.avatar)
                                addFriend(addreqID,addreqNick ,addreqAvatar ,addreqGender ,addreqArea ,addreqSig ,addreqMemo)
                                isContactsUpdate = true
                            }
                        }
                    }
                }
            }
        }
    }
}

