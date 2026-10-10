// WeatherService.js - Open-Meteo REST Client for Nokia N9
.pragma library

function getWeatherInfo(code, isDay) {
    if (code === undefined || code === null) {
        return { desc: "Bilinmiyor", anim: "CLOUDY" };
    }
    if (code === 0) {
        return {
            desc: isDay ? "Açık & Güneşli" : "Açık Gece",
            anim: isDay ? "SUNNY" : "NIGHT_CLEAR"
        };
    }
    if (code === 1) {
        return { desc: "Az Bulutlu", anim: isDay ? "SUNNY" : "CLOUDY" };
    }
    if (code === 2) {
        return { desc: "Parçalı Bulutlu", anim: "CLOUDY" };
    }
    if (code === 3) {
        return { desc: "Çok Bulutlu / Kapalı", anim: "CLOUDY" };
    }
    if (code === 45 || code === 48) {
        return { desc: "Sisli", anim: "CLOUDY" };
    }
    if (code >= 51 && code <= 57) {
        return { desc: "Çiseleyen Yağmur", anim: "RAINY" };
    }
    if (code >= 61 && code <= 67) {
        return { desc: "Yağmurlu", anim: "RAINY" };
    }
    if (code >= 71 && code <= 77) {
        return { desc: "Kar Yağışlı", anim: "SNOWY" };
    }
    if (code >= 80 && code <= 82) {
        return { desc: "Sağanak Yağış", anim: "RAINY" };
    }
    if (code >= 85 && code <= 86) {
        return { desc: "Kar Sağanağı", anim: "SNOWY" };
    }
    if (code >= 95) {
        return { desc: "Gök Gürültülü Fırtına", anim: "THUNDER" };
    }
    return { desc: "Bulutlu", anim: "CLOUDY" };
}

function parseDayName(dateStr, index) {
    if (index === 0) return "Bugün";
    try {
        var parts = dateStr.split("-");
        if (parts.length === 3) {
            var y = parseInt(parts[0], 10);
            var m = parseInt(parts[1], 10) - 1;
            var d = parseInt(parts[2], 10);
            var dt = new Date(y, m, d);
            var days = ["Pzr", "Pzt", "Sal", "Çar", "Per", "Cum", "Cmt"];
            var dayIdx = dt.getDay();
            if (!isNaN(dayIdx) && dayIdx >= 0 && dayIdx < 7) {
                return days[dayIdx];
            }
        }
    } catch (e) {}
    return "Gün " + (index + 1);
}

function fetchWeather(latitude, longitude, callback) {
    if (!latitude) latitude = 38.35;
    if (!longitude) longitude = 28.51;

    var endpoint = "http://api.open-meteo.com/v1/forecast?" +
        "latitude=" + latitude +
        "&longitude=" + longitude +
        "&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,weather_code,wind_speed_10m" +
        "&hourly=temperature_2m,weather_code" +
        "&daily=weather_code,temperature_2m_max,temperature_2m_min" +
        "&timezone=auto";

    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status === 200) {
                try {
                    var data = JSON.parse(xhr.responseText);
                    parseWeatherData(data, callback);
                } catch (e) {
                    callback(false, "JSON Hatası: " + e.message);
                }
            } else {
                callback(false, "Ağ Hatası: " + xhr.status);
            }
        }
    };
    xhr.open("GET", endpoint, true);
    xhr.send();
}

function parseWeatherData(raw, callback) {
    var result = {};
    var current = raw.current || {};
    var isDay = current.is_day === 1;
    var wCode = current.weather_code !== undefined ? current.weather_code : 0;
    var info = getWeatherInfo(wCode, isDay);

    result.current = {
        temp: Math.round(current.temperature_2m !== undefined ? current.temperature_2m : 0),
        apparentTemp: Math.round(current.apparent_temperature !== undefined ? current.apparent_temperature : 0),
        humidity: current.relative_humidity_2m !== undefined ? current.relative_humidity_2m : 0,
        windSpeed: Math.round(current.wind_speed_10m !== undefined ? current.wind_speed_10m : 0),
        precipitation: current.precipitation !== undefined ? current.precipitation : 0.0,
        isDay: isDay,
        weatherCode: wCode,
        description: info.desc,
        animationType: info.anim
    };

    // Saatlik Tahmin: Bulunduğumuz saatten başlayarak sonraki 24 saati al
    result.hourly = [];
    if (raw.hourly && raw.hourly.time && raw.hourly.temperature_2m) {
        var now = new Date();
        var curHour = now.getHours();
        var startIdx = 0;

        // Günün şu anki saatine en yakın indeksi bul
        for (var k = 0; k < Math.min(24, raw.hourly.time.length); k++) {
            var tStr = raw.hourly.time[k];
            if (tStr.indexOf("T") !== -1) {
                var hourNum = parseInt(tStr.split("T")[1].substring(0, 2), 10);
                if (hourNum === curHour) {
                    startIdx = k;
                    break;
                }
            }
        }

        var totalHours = raw.hourly.time.length;
        for (var h = 0; h < 24 && (startIdx + h) < totalHours; h++) {
            var idx = startIdx + h;
            var timePart = raw.hourly.time[idx];
            var displayTime = timePart.indexOf("T") !== -1 ? timePart.split("T")[1].substring(0, 5) : timePart;
            if (h === 0) displayTime = "Şimdi";

            var hCode = raw.hourly.weather_code ? raw.hourly.weather_code[idx] : 0;
            var hHour = parseInt(displayTime.substring(0, 2), 10);
            var hIsDay = (hHour >= 6 && hHour < 20);

            result.hourly.push({
                time: displayTime,
                temp: Math.round(raw.hourly.temperature_2m[idx]) + "°",
                code: hCode,
                isDay: hIsDay
            });
        }
    }

    // 7 Günlük Tahmin: Sağlam tarih çözümleme ile
    result.daily = [];
    if (raw.daily && raw.daily.time && raw.daily.temperature_2m_max) {
        var dCount = Math.min(7, raw.daily.time.length);
        for (var d = 0; d < dCount; d++) {
            var dateStr = raw.daily.time[d];
            var dayLabel = parseDayName(dateStr, d);
            var dCode = raw.daily.weather_code ? raw.daily.weather_code[d] : 0;
            var dInfo = getWeatherInfo(dCode, true);

            result.daily.push({
                day: dayLabel,
                maxTemp: Math.round(raw.daily.temperature_2m_max[d]) + "°",
                minTemp: Math.round(raw.daily.temperature_2m_min[d]) + "°",
                code: dCode,
                desc: dInfo.desc
            });
        }
    }

    callback(true, result);
}
