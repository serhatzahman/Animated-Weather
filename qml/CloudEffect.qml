import QtQuick 1.1

Item {
    id: cloudEffectRoot
    anchors.fill: parent
    clip: true

    // Üst Seviye Yavaş Bulut
    Image {
        id: cloudHigh
        y: 50
        opacity: 0.45
        scale: 0.8
        source: "../images/cloud.png"
        NumberAnimation on x {
            from: -260; to: 480
            duration: 34000
            loops: Animation.Infinite
        }
    }

    // Orta Seviye Ana Bulut
    Image {
        id: cloudMid
        y: 110
        opacity: 0.75
        scale: 1.1
        source: "../images/cloud.png"
        NumberAnimation on x {
            from: -280; to: 480
            duration: 22000
            loops: Animation.Infinite
        }
    }

    // Alt Seviye Hızlı Bulut
    Image {
        id: cloudLow
        y: 180
        opacity: 0.55
        scale: 0.95
        source: "../images/cloud.png"
        NumberAnimation on x {
            from: -250; to: 480
            duration: 17000
            loops: Animation.Infinite
        }
    }
}
