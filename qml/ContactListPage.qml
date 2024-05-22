import QtQuick
import QtQuick.Shapes 1.7

Rectangle {
    id:contactsPage

    width: parent.width
    height: parent.height

    function add_to_contacts(){
        name_model.append({name:"GGBone" , firstLetter:"G"})
    }

    function remove_from_contacts(){
        var rowCount = name_model.count;
        for( var i = 0;i < rowCount;i++ ) {
            if(model === contacts_Model.get(i))
            // console.log(model.value)
                name_model.remove({name:"GGBone" , firstLetter:"G"})
        }
    }

    // top
    ListModel {
        id: contacts_model

        ListElement {
            name: "新的朋友"
            avatar_path: "../assets/Picture/icons/newfriend.png"
        }

        ListElement {
            name: "群聊"
            avatar_path: "../assets/Picture/icons/group_people.png"
        }

        ListElement {
            name: "标签"
            avatar_path: "../assets/Picture/icons/label.png"
        }
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
       }
    }

    ListModel {
        id: name_model
        ListElement { name: "Alice" ; firstLetter: "A";avatar_path: "../assets/Picture/icons/newfriend.png"}
        ListElement { name: "Bob" ; firstLetter: "A";avatar_path: "../assets/Picture/icons/newfriend.png"}
        ListElement { name: "Carol" ; firstLetter: "A";avatar_path: "../assets/Picture/icons/newfriend.png"}
        ListElement { name: "David" ; firstLetter: "D";avatar_path: "../assets/Picture/icons/newfriend.png"}
        ListElement { name: "Ella" ; firstLetter: "E";avatar_path: "../assets/Picture/icons/newfriend.png"}
        ListElement { name: "Flla" ; firstLetter: "F";avatar_path: "../assets/Picture/icons/newfriend.png"}
        ListElement { name: "Alice" ; firstLetter: "G";avatar_path: "../assets/Picture/icons/newfriend.png"}
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
                        Rectangle{width: 10; height:model.firstLetter === parentItem.letter ? avatar.height+20 : 0.1}
                        Image{
                            id: avatar
                            width: contactsPage.width / 11
                            height: model.firstLetter === parentItem.letter ? width : 0
                            source: model.firstLetter === parentItem.letter ? model.avatar_path : ""
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
                                text: model.firstLetter === parentItem.letter ? model.name : ""
                                height: model.firstLetter === parentItem.letter ? 20 : 0.1
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


