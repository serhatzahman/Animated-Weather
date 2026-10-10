import QtQuick 1.1

Rectangle {
    id: cardRoot
    property real cardWidth: 214
    property string badgeText: "BİLGİ"
    property string badgeColor: "#64B5F6"
    property string label: "Başlık"
    property string value: "--"

    width: cardWidth
    height: 98
    radius: 18
    color: "#1AFFFFFF"
    border.color: "#35FFFFFF"
    border.width: 1

    Row {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 14

        Rectangle {
            width: 56
            height: 56
            radius: 14
            color: "#28" + badgeColor.replace("#", "")
            border.color: "#55" + badgeColor.replace("#", "")
            border.width: 2
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: badgeText
                color: badgeColor
                font.pixelSize: 16
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5

            Text {
                text: label
                color: "#B0BEC5"
                font.pixelSize: 16
            }

            Text {
                text: value
                color: "#FFFFFF"
                font.pixelSize: 25
                font.bold: true
            }
        }
    }
}
