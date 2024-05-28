import QtQuick

Rectangle {
    width: parent.width
    height: parent.height

    ListModel {
        id: contacts_model

        ListElement {
            name: "test"
            avatar_path: Image {
                id: avatar_1
                source: "../assets/Picture/icons/person.png"
            }
            attributes: [
                ListElement { description: "Core" },
                ListElement { description: "Deciduous" }
            ]
        }
        // fruitModel.append({"cost": 5.95, "name":"Pizza"})
        ListElement {
            name: "Orange"
            cost: 3.25
            attributes: [
                ListElement { description: "Citrus" }
            ]
        }
        ListElement {
            name: "Banana"
            cost: 1.95
            attributes: [
                ListElement { description: "Tropical" },
                ListElement { description: "Seedless" }
            ]
        }
    }

    Component {
        id: fruitDelegate
        Row {
            spacing: 10
            Text { text: name }
            Text { text: '$' + cost }
        }
    }

    ListView {
        anchors.fill: parent
        model: contacts_model
        delegate: fruitDelegate
    }
}
