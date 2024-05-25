import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    Loader{
        id:showFriendLoader
        anchors.fill: parent
    }

    width: parent.width
    height: parent.height
    anchors.fill: parent
    color: "pink"
    Text{
        text:"showfriendpage"
    }
    Button{
        text:"back"
        TapHandler{
            onTapped: {
                showFriendLoader.source
            }
        }
    }
}
