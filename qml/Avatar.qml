import QtQuick
import Qt5Compat.GraphicalEffects

Rectangle{
    property alias source: image.source
    property alias avatar: avatar
    //缩略图本体
    id:avatar
    width: 50
    height: 50
    border.color: "black"
    border.width: 0.5
    Image {
         id: image
         source:"qrc:/assets/Picture/avatar/11111.jpg"
         asynchronous: true
         anchors.centerIn: parent
         width: 40
         height: 40
         //使用PreserveAspectFit确保在原始比例下不会变形
         fillMode: Image.PreserveAspectFit
         clip: true
         visible: false //因为显示的是OpacityMask需要false
     }

     //圆角遮罩Rectangle
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
         visible: false //因为显示的是OpacityMask需要false
     }

     //遮罩后的图案
     OpacityMask {
         id: mask
         anchors.fill: image
         source: image
         maskSource: maskRec
     }
}
