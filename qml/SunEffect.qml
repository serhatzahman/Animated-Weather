import QtQuick 1.1

Item {
    id: sunEffectRoot
    anchors.fill: parent
    clip: true

    // Güneş Aurası (Köşeye ve derine yerleştirildi)
    Rectangle {
        id: sunAura
        x: parent.width - 150
        y: -30
        width: 240
        height: 240
        radius: 120
        color: "#14FFC107"
        border.color: "#25FFD54F"
        border.width: 1

        SequentialAnimation on scale {
            loops: Animation.Infinite
            NumberAnimation { to: 1.12; duration: 3400; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.94; duration: 3400; easing.type: Easing.InOutSine }
        }
    }

    // Güneş Çekirdeği
    Rectangle {
        id: sunCore
        x: parent.width - 100
        y: 10
        width: 120
        height: 120
        radius: 60
        color: "#FFA000"

        Rectangle {
            anchors.centerIn: parent
            width: 96
            height: 96
            radius: 48
            color: "#FFD54F"
        }

        // Işık Huzmeleri
        Repeater {
            model: 8
            Rectangle {
                width: 3
                height: 20
                color: "#FFE082"
                radius: 1.5
                x: 58.5
                y: -14
                transformOrigin: Item.Bottom
                rotation: index * 45
            }
        }

        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 40000
            loops: Animation.Infinite
        }
    }

    // Arka Planda Kayan Yumuşak Bulut
    Image {
        y: 180
        opacity: 0.25
        source: "../images/cloud.png"
        NumberAnimation on x {
            from: -240
            to: 480
            duration: 32000
            loops: Animation.Infinite
        }
    }
}
