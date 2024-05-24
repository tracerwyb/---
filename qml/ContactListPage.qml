import QtQuick
import QtQuick.Shapes 1.7

Rectangle {
    id:contactsPage

    width: parent.width
    height: parent.height

    readonly property url addfriendPage_loader: "AddfriendPage.qml"
    // readonly property url groupList_loader: "AddfriendPage.qml"
    // readonly property url label_loader: "AddfriendPage.qml"

    function add_to_contacts(name, first_letter, avatar_path = "../assets/Picture/icons/newfriend.png"){
        name_model.append({name:name , first_letter:first_letter, avatar_path: avatar_path})
    }

    function remove_from_contacts(name, first_letter, avatar_path = "../assets/Picture/icons/newfriend.png"){
        var rowCount = name_model.count;

        for(i = 0;i < name_model.count;i++){
            if(name === contacts_Model.get(i).name)
            // console.log(model.value)
                name_model.remove({name:name , first_letter:first_letter, avatar_path: avatar_path})
        }


    }

    Connections{
        target: afController

        function onAddFriChanged(friend_name, first_letter, avatar_path) {
            if(afcontroller.getAddFri() === 1){
                afcontroller.setAddfri(0);
                add_to_contacts(friend_name, first_letter, avatar_path);
                console.log("add to contact")
            }else if(afcontroller.getAddFri() === -1){
                afcontroller.setAddfri(0);
                remove_from_contacts(friend_name, first_letter, avatar_path);
                console.log("remove from contact")
            }
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
        ListElement { name: "Alice" ; first_letter: "A";avatar_path: "../assets/Picture/icons/newfriend.png"}
        ListElement { name: "Bob" ; first_letter: "A";avatar_path: "../assets/Picture/icons/newfriend.png"}
        ListElement { name: "Carol" ; first_letter: "A";avatar_path: "../assets/Picture/icons/newfriend.png"}
        ListElement { name: "David" ; first_letter: "D";avatar_path: "../assets/Picture/icons/newfriend.png"}
        ListElement { name: "Ella" ; first_letter: "E";avatar_path: "../assets/Picture/icons/newfriend.png"}
        ListElement { name: "Flla" ; first_letter: "F";avatar_path: "../assets/Picture/icons/newfriend.png"}
        ListElement { name: "Alice" ; first_letter: "G";avatar_path: "../assets/Picture/icons/newfriend.png"}
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
            height:200
            model: contacts_model
            delegate: contacts_delegate
        }
    }



    ListView {
        y: top.height
        width: parent.width
        height:parent.height - top.height
        model: 26 // A-Z 字母的数量
        spacing: 10
        delegate: Item {
            id:parentItem
            width: contactsPage.width
            height: childrenRect.height

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

                    width: parent.width
                    height: contentHeight
                    model: name_model
                    delegate:Row{
                        Rectangle{width: 10; height:model.first_letter === parentItem.letter ? avatar.height+20 : 0.1}
                        Image{
                            id: avatar
                            width: contactsPage.width / 11
                            height: model.first_letter === parentItem.letter ? width : 0
                            source: model.first_letter === parentItem.letter ? model.avatar_path : ""
                            fillMode: Image.PreserveAspectFit
                        }
                        Rectangle{width: 10; height:0.1}
                        Rectangle{
                            id: rect
                            width: user.width - 20 - avatar.width
                            height: avatar.height
                            color: "red"
                            border.color: "#E8E8E8"
                            Rectangle{
                                // anchors{
                                //     fill: rect;
                                //     bottomMargin:rect.border.width;
                                // }
                                width: parent.width
                                height: 0.6
                                border.color: "#c7c7c7"
                                border.width: 0.6
                                anchors.bottom:parent.bottom
                            }
                            Text {
                                text: model.first_letter === parentItem.letter ? model.name : ""
                                height: model.first_letter === parentItem.letter ? 20 : 0.1
                                font.italic: true
                                anchors.verticalCenter: parent.verticalCenter

                            }
                        }

                    }
                }
            }
        }
    }
}


