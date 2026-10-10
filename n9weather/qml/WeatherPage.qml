import QtQuick 1.1
import com.nokia.meego 1.0
import "WeatherService.js" as WeatherService

Page {
    id: weatherPage
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    property string currentCity: "Alaşehir"
    property real latitude: 38.35
    property real longitude: 28.51

    property string tempText: "--°"
    property string descText: "Yükleniyor..."
    property int currentWeatherCode: 0
    property string animType: "SUNNY"
    property bool isDayTime: true

    property string apparentText: "--°C"
    property string humidityText: "--%"
    property string windText: "-- km/s"
    property string precipText: "-- mm"
    property string updatedTime: ""

    Rectangle {
        id: bgGradient
        anchors.fill: parent

        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: {
                    if (!isDayTime) return "#060A14";
                    if (animType === "RAINY" || animType === "THUNDER") return "#1E293B";
                    if (animType === "CLOUDY") return "#1A2E40";
                    return "#1565C0";
                }
            }
            GradientStop {
                position: 0.55
                color: {
                    if (!isDayTime) return "#0D1829";
                    if (animType === "RAINY" || animType === "THUNDER") return "#0F172A";
                    return "#0D47A1";
                }
            }
            GradientStop {
                position: 1.0
                color: "#000000"
            }
        }
    }

    SunEffect { visible: animType === "SUNNY" && isDayTime }
    CloudEffect { visible: animType === "CLOUDY" }
    RainEffect {
        visible: animType === "RAINY" || animType === "THUNDER"
        isThunderstorm: animType === "THUNDER"
    }

    Flickable {
        id: mainScroll
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: contentCol.height + 120
        flickableDirection: Flickable.VerticalFlick
        clip: true

        Column {
            id: contentCol
            y: 18
            width: parent.width
            spacing: 28

            // Hero Alanı
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 8

                // Şehir Seçici Kapsülü (26px font)
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: cityRow.width + 44
                    height: 52
                    radius: 26
                    color: "#35FFFFFF"
                    border.color: "#55FFFFFF"

                    Row {
                        id: cityRow
                        anchors.centerIn: parent
                        spacing: 12
                        Rectangle {
                            width: 12
                            height: 12
                            radius: 6
                            color: "#64B5F6"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: currentCity
                            color: "#FFFFFF"
                            font.pixelSize: 25
                            font.bold: true
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "▾"
                            color: "#90CAF9"
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: cityDialog.open()
                    }
                }

                // Dev Sıcaklık (130px)
                Text {
                    text: tempText
                    color: "#FFFFFF"
                    font.pixelSize: 130
                    font.weight: Font.Light
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // Hava Durumu İkonu (48px) ve Açıklaması (30px Bold)
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 14
                    WeatherIcon {
                        weatherCode: currentWeatherCode
                        isDay: isDayTime
                        size: 48
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: descText
                        color: "#FFFFFF"
                        font.pixelSize: 30
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Text {
                    text: updatedTime ? "Güncelleme: " + updatedTime : ""
                    color: "#90A4AE"
                    font.pixelSize: 15
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            // Saatlik Tahmin Bölümü (Geniş Kartlar)
            Column {
                width: parent.width
                spacing: 14

                Text {
                    text: "Saatlik Tahmin"
                    color: "#B0BEC5"
                    font.pixelSize: 23
                    font.bold: true
                    x: 20
                }

                ListView {
                    id: hourlyList
                    x: 20
                    width: parent.width - 40
                    height: 146
                    orientation: ListView.Horizontal
                    spacing: 14
                    clip: true

                    model: ListModel { id: hourlyModel }

                    delegate: Rectangle {
                        width: 92
                        height: 142
                        radius: 20
                        color: "#22FFFFFF"
                        border.color: "#35FFFFFF"

                        Column {
                            anchors.centerIn: parent
                            spacing: 10
                            Text {
                                text: model.time
                                color: "#ECEFF1"
                                font.pixelSize: 18
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            WeatherIcon {
                                weatherCode: model.code
                                isDay: model.isDay
                                size: 44
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: model.temp
                                color: "#FFFFFF"
                                font.pixelSize: 24
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }

            // 7 Günlük Tahmin Bölümü
            Column {
                width: parent.width
                spacing: 14

                Text {
                    text: "7 Günlük Tahmin"
                    color: "#B0BEC5"
                    font.pixelSize: 23
                    font.bold: true
                    x: 20
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - 40
                    height: dailyCol.height + 28
                    radius: 22
                    color: "#18FFFFFF"
                    border.color: "#30FFFFFF"

                    Column {
                        id: dailyCol
                        anchors.top: parent.top
                        anchors.topMargin: 14
                        width: parent.width
                        spacing: 14

                        Repeater {
                            id: dailyRepeater
                            model: ListModel { id: dailyModel }

                            delegate: Item {
                                width: parent.width - 24
                                x: 12
                                height: 50

                                Text {
                                    id: dayText
                                    text: model.day
                                    color: model.day === "Bugün" ? "#64B5F6" : "#FFFFFF"
                                    font.pixelSize: 21
                                    font.bold: true
                                    width: 76
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                WeatherIcon {
                                    id: rowIcon
                                    weatherCode: model.code
                                    isDay: true
                                    size: 38
                                    anchors.left: dayText.right
                                    anchors.leftMargin: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Text {
                                    text: model.desc
                                    color: "#CFD8DC"
                                    font.pixelSize: 17
                                    anchors.left: rowIcon.right
                                    anchors.leftMargin: 12
                                    anchors.right: tempRow.left
                                    anchors.rightMargin: 12
                                    elide: Text.ElideRight
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                Row {
                                    id: tempRow
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 12
                                    Text {
                                        text: model.maxTemp
                                        color: "#FFFFFF"
                                        font.pixelSize: 21
                                        font.bold: true
                                    }
                                    Text {
                                        text: model.minTemp
                                        color: "#90A4AE"
                                        font.pixelSize: 18
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Koşul Detayları Bölümü
            Column {
                width: parent.width
                spacing: 14

                Text {
                    text: "Koşul Detayları"
                    color: "#B0BEC5"
                    font.pixelSize: 23
                    font.bold: true
                    x: 20
                }

                Grid {
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 2
                    spacing: 12

                    WeatherDetailCard {
                        cardWidth: 214
                        badgeText: "HİS"
                        badgeColor: "#FF7043"
                        label: "Hissedilen"
                        value: apparentText
                    }
                    WeatherDetailCard {
                        cardWidth: 214
                        badgeText: "NEM"
                        badgeColor: "#29B6F6"
                        label: "Nem Oranı"
                        value: humidityText
                    }
                    WeatherDetailCard {
                        cardWidth: 214
                        badgeText: "RÜZ"
                        badgeColor: "#26A69A"
                        label: "Rüzgar Hızı"
                        value: windText
                    }
                    WeatherDetailCard {
                        cardWidth: 214
                        badgeText: "YAĞ"
                        badgeColor: "#AB47BC"
                        label: "Yağış"
                        value: precipText
                    }
                }
            }

            Item { width: parent.width; height: 95 }
        }
    }

    SelectionDialog {
        id: cityDialog
        titleText: "Şehir Seçiniz"
        model: ListModel {
            ListElement { name: "Alaşehir"; lat: 38.35; lon: 28.51 }
            ListElement { name: "Manisa"; lat: 38.61; lon: 27.42 }
            ListElement { name: "İzmir"; lat: 38.41; lon: 27.13 }
            ListElement { name: "İstanbul"; lat: 41.00; lon: 28.97 }
            ListElement { name: "Ankara"; lat: 39.93; lon: 32.85 }
            ListElement { name: "Antalya"; lat: 36.89; lon: 30.70 }
        }
        onSelectedIndexChanged: {
            if (selectedIndex >= 0) {
                var selected = model.get(selectedIndex);
                currentCity = selected.name;
                latitude = selected.lat;
                longitude = selected.lon;
                refreshWeather();
            }
        }
    }

    function openCityPicker() { cityDialog.open(); }

    function refreshWeather() {
        descText = "Güncelleniyor...";
        WeatherService.fetchWeather(latitude, longitude, function(success, result) {
            if (success) {
                var cur = result.current;
                tempText = cur.temp + "°";
                descText = cur.description;
                currentWeatherCode = cur.weatherCode;
                animType = cur.animationType;
                isDayTime = cur.isDay;

                apparentText = cur.apparentTemp + "°C";
                humidityText = "%" + cur.humidity;
                windText = cur.windSpeed + " km/s";
                precipText = cur.precipitation + " mm";

                var now = new Date();
                var hh = ("0" + now.getHours()).slice(-2);
                var mm = ("0" + now.getMinutes()).slice(-2);
                updatedTime = hh + ":" + mm;

                hourlyModel.clear();
                for (var i = 0; i < result.hourly.length; i++) {
                    hourlyModel.append(result.hourly[i]);
                }

                dailyModel.clear();
                for (var d = 0; d < result.daily.length; d++) {
                    dailyModel.append(result.daily[d]);
                }
            } else {
                descText = "Bağlantı Kurulamadı";
            }
        });
    }

    Component.onCompleted: { refreshWeather(); }
}
