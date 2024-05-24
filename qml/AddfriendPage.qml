import QtQuick
import Qt5Compat.GraphicalEffects

Rectangle {
    id: newfriend
    width: parent.width
    height: parent.height

    readonly property url showFriend_loader: "ShowFriend.qml"

    property bool loaderVisible : false

    signal searchTextChanged(var text)

    Component.onCompleted: {
        searchTextChanged.connect(afController.onSearchTextChanged)
    }

    Connections{
        target: afController
        function onFriendBaseInfo(text){
            console.log("on friend base info called")
            return JSON.parse(text)
        }
    }

    Loader{
        id: loader
        asynchronous: true
        anchors.fill: parent
        source: showFriend_loader
        visible: loaderVisible
    }

    Rectangle
    {
        id:searchBar
        y: parent.height * 0.05
        anchors.horizontalCenter: parent.horizontalCenter
        width:newfriend.width * 0.9
        height: newfriend.height / 14
        border.color: "#e8e8e8"
        border.width: 1
        radius: searchBar.height / 2
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
                    searchTextChanged(search_content.text)
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
                    searchTextChanged(search_content.text)
                    searchBar.visible = false

                    titlecolor = "#ffffff"
                    // loader.source = showFriend_loader
                    loaderVisible = true
                }
            }
        }
    }


}

