import QtQuick 1.1

Item {
    id: rainEffectRoot
    anchors.fill: parent
    clip: true

    property bool isThunderstorm: false

    // Şimşek Çakma Efekti (Fırtına Modunda)
    Rectangle {
        id: lightningOverlay
        anchors.fill: parent
        color: "#FFFFFF"
        opacity: 0.0
        visible: rainEffectRoot.isThunderstorm
        z: 99

        SequentialAnimation {
            id: flashAnim
            loops: Animation.Infinite
            PauseAnimation { duration: 4500 }
            NumberAnimation { target: lightningOverlay; property: "opacity"; to: 0.65; duration: 60 }
            NumberAnimation { target: lightningOverlay; property: "opacity"; to: 0.1; duration: 40 }
            NumberAnimation { target: lightningOverlay; property: "opacity"; to: 0.8; duration: 80 }
            NumberAnimation { target: lightningOverlay; property: "opacity"; to: 0.0; duration: 180 }
        }

        Component.onCompleted: {
            if (rainEffectRoot.isThunderstorm) {
                flashAnim.start();
            }
        }
    }

    // Kayan Koyu Fırtına Bulutları
    Image {
        y: 60
        opacity: 0.85
        source: "../images/cloud.png"
        NumberAnimation on x {
            from: -260; to: 480
            duration: 18000
            loops: Animation.Infinite
        }
    }

    // Düşen Yağmur Damlaları (Nokia N9 AMOLED 60fps optimizeli)
    Repeater {
        model: 22
        Rectangle {
            id: drop
            width: (index % 3 === 0) ? 2.5 : 1.5
            height: 14 + (index % 5) * 2
            color: "#B2EBF2"
            opacity: 0.5 + (index % 5) * 0.1
            x: (index * 22) + (Math.random() * 8)
            y: -30
            rotation: 6 // Hafif rüzgar açısı

            SequentialAnimation on y {
                loops: Animation.Infinite
                PauseAnimation { duration: index * 75 }
                NumberAnimation {
                    from: -30
                    to: 854
                    duration: 750 + (index % 4) * 50
                    easing.type: Easing.Linear
                }
            }
        }
    }
}
