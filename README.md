# N9 Weather (Hava Durumu) for Nokia N9 (MeeGo 1.2 Harmattan)

[![Platform](https://img.shields.io/badge/platform-MeeGo%201.2%20Harmattan-blue.svg)](https://en.wikipedia.org/wiki/MeeGo)
[![Device](https://img.shields.io/badge/device-Nokia%20N9%20%7C%20N950-brightgreen.svg)](#)
[![Framework](https://img.shields.io/badge/framework-Qt%20Quick%201.1%20%2F%20PySide-orange.svg)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

An elegant, animated, portrait weather application designed specifically for the iconic **Nokia N9** running **MeeGo 1.2 Harmattan**. Built with **Qt Quick 1.1 (QML)** and powered by the **Open-Meteo REST API**.

*Nokia N9 (MeeGo 1.2 Harmattan) için özel olarak geliştirilmiş, akıcı QML animasyonlarına ve AMOLED saf siyah temasına sahip dikey hava durumu uygulaması.*

---

## 📸 Screenshots / Ekran Görüntüleri

| Running on Nokia N9 / Cihazda Çalışırken | UI Screen Preview / Arayüz Görünümü | MeeGo Launcher Icon / Menü Simgesi |
| :---: | :---: | :---: |
| ![Nokia N9 Running Weather](<img width="480" height="854" alt="Screenshot_20261010_114419" src="https://github.com/user-attachments/assets/10b4fd54-d518-41fc-8130-442d13932f44" />
) | ![Nokia N9 Weather UI](<img width="480" height="854" alt="Screenshot_20261010_114430" src="https://github.com/user-attachments/assets/bdeca8df-51af-4f51-9297-32649f3ff622" />) | ![Nokia N9 Launcher](<img width="480" height="854" alt="Screenshot_20261010_114440" src="https://github.com/user-attachments/assets/b36ed3a3-f695-45d4-9017-311a3747c39d" />) |

---

## 🌐 English

### Key Features
* **Tailored for Nokia N9 AMOLED Screen:** Native 480×854 FWVGA portrait orientation with a dynamic true-black (`#000000`) gradient to preserve battery life.
* **Fluid Procedural Animations:**
  * **Sunny:** Rotating sun rays and pulsating golden ambient aura.
  * **Cloudy:** Multi-layered parallax drifting clouds.
  * **Rainy & Thunderstorm:** Smooth 60 FPS rain streaks with realistic angles and randomized lightning flashes.
* **Pure QML Scalable Vector Icons:** Custom hardware-accelerated QML vector weather icons designed specifically for Nokia N9, avoiding broken missing-glyph tofu boxes (`[]`) on legacy font engines.
* **Harmattan OpenSSL & TLS Compatible:** Connects via a lightweight HTTP endpoint to Open-Meteo REST API, circumventing obsolete TLS 1.0/1.1 root certificate expiration issues on legacy MeeGo firmware.
* **Comprehensive Weather Data:**
  * Current temperature, condition description, and last update timestamp.
  * **Hourly Forecast:** 24-hour horizontal scrolling forecast dynamically starting from the current hour.
  * **7-Day Daily Forecast:** Extended weekly outlook with high/low temperature ranges.
  * **Detailed Metrics Cards:** Apparent temperature, relative humidity, wind speed, and precipitation.
  * **City Switcher:** Built-in selection dialog with quick switching between cities.
* **Native MeeGo Harmattan Experience:** MeeGo Touch squircle icon (`80x80`), MeeGo bottom ToolBar integration, and home-screen launcher support.

---

### Installation & Quick Start

#### Method A: Instant Run via PySide (No Compilation Needed)
Nokia N9 PR 1.2 / PR 1.3 includes Python and PySide out of the box.

1. **Transfer files to phone via SCP:**
   ```bash
   scp -O -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -r n9weather user@<PHONE_IP>:/home/user/
   ```
2. **Run on phone over SSH:**
   ```bash
   ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa user@<PHONE_IP>
   export DISPLAY=:0
   python /home/user/n9weather/run.py
   ```

#### Method B: Permanent System Installation (Add to App Menu)
Log in via SSH and execute with root privileges (`devel-su`, default password: `rootme`):
```bash
devel-su -c '
# Create system folders
mkdir -p /opt/n9weather /usr/share/icons/hicolor/80x80/apps/ /usr/share/themes/base/meegotouch/icons/

# Copy application files
cp -r /home/user/n9weather/qml /opt/n9weather/
cp -r /home/user/n9weather/images /opt/n9weather/
cp /home/user/n9weather/run.py /opt/n9weather/

# Create launcher binary
cat << "EOF" > /opt/n9weather/n9weather
#!/bin/sh
export DISPLAY=:0
exec python /opt/n9weather/run.py
EOF
chmod +x /opt/n9weather/n9weather

# Install MeeGo squircle icons
cp /opt/n9weather/images/n9weather80.png /usr/share/themes/base/meegotouch/icons/n9weather80.png
cp /opt/n9weather/images/n9weather80.png /usr/share/icons/hicolor/80x80/apps/n9weather80.png

# Install Desktop Entry
cp /home/user/n9weather/n9weather.desktop /usr/share/applications/

# Refresh application launcher
update-desktop-database
killall m-desktop
'
```

#### Method C: Compile Native Binary with Qt Creator / Scratchbox
Open `n9weather.pro` with Nokia Qt SDK targeting Harmattan or build with `dpkg-buildpackage -rfakeroot -uc -us` to generate a `.deb` package.

---

## 🇹🇷 Türkçe

### Temel Özellikler
* **Nokia N9 AMOLED Ekranına Özel Tasarım:** 480×854 FWVGA dikey mod, alt kısımda saf siyah (`#000000`) AMOLED pil dostu gradyan.
* **Akıcı QML Efektleri:**
  * **Güneşli:** Dönen ışık huzmeleri ve nabız gibi atan altın parlama aurası.
  * **Bulutlu:** Farklı derinliklerde kayan çok katmanlı bulutlar.
  * **Yağmurlu & Fırtınalı:** Açılı düşen 60 FPS yağmur damlaları ve rastgele şimşek parlamaları.
* **Kırılmayan Saf QML Vektörel İkonlar:** N9'un eski yazı tipi motorunda emojilerin boş kutucuk (`[]`) olarak görünmesini engelleyen, donanım hızlandırmalı yerel vektör hava durumu simgeleri.
* **MeeGo TLS / SSL Uyumlu:** N9'un eskiyen sertifikalarından etkilenmeden Open-Meteo REST API'si üzerinden hafif HTTP ile canlı hava verisi çeker.
* **Kapsamlı Hava Durumu Bilgisi:**
  * Anlık sıcaklık, hava durumu açıklaması ve son güncelleme saati.
  * **Saatlik Tahmin:** İçinde bulunulan saatten başlayan 24 saatlik yatay kaydırma çubuğu.
  * **7 Günlük Tahmin:** Türkçe gün adlarıyla haftalık en yüksek / en düşük sıcaklık görünümü.
  * **Detay Kartları:** Hissedilen sıcaklık, nem oranı, rüzgar hızı ve yağış miktarı.
  * **Şehir Seçici:** Alaşehir (varsayılan), Manisa, İzmir, İstanbul, Ankara ve Antalya arasında hızlı geçiş.
* **MeeGo Harmattan Entegrasyonu:** Resmi 80×80 squircle simge, MeeGo alt araç çubuğu ve uygulama çekmecesi başlatıcısı.

---

### Kurulum ve Kullanım

#### Yöntem A: PySide ile Hızlı Çalıştırma (Derleme Gerekmez)
Nokia N9 PR 1.2 / PR 1.3 sürümlerinde Python ve PySide varsayılan olarak hazırdır.

1. **Dosyaları SCP ile telefona gönderin:**
   ```bash
   scp -O -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -r n9weather user@<TELEFON_IP>:/home/user/
   ```
2. **Telefonda çalıştırın:**
   ```bash
   ssh -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa user@<TELEFON_IP>
   export DISPLAY=:0
   python /home/user/n9weather/run.py
   ```

#### Yöntem B: Menüye Kalıcı Kurulum
SSH oturumunda root yetkisiyle (`devel-su`, şifre: `rootme`) şu komutu yapıştırın:
```bash
devel-su -c '
mkdir -p /opt/n9weather /usr/share/icons/hicolor/80x80/apps/ /usr/share/themes/base/meegotouch/icons/

cp -r /home/user/n9weather/qml /opt/n9weather/
cp -r /home/user/n9weather/images /opt/n9weather/
cp /home/user/n9weather/run.py /opt/n9weather/

cat << "EOF" > /opt/n9weather/n9weather
#!/bin/sh
export DISPLAY=:0
exec python /opt/n9weather/run.py
EOF
chmod +x /opt/n9weather/n9weather

cp /opt/n9weather/images/n9weather80.png /usr/share/themes/base/meegotouch/icons/n9weather80.png
cp /opt/n9weather/images/n9weather80.png /usr/share/icons/hicolor/80x80/apps/n9weather80.png

cp /home/user/n9weather/n9weather.desktop /usr/share/applications/

update-desktop-database
killall m-desktop
'
```

---

## 📁 Project Structure / Proje Mimarisi

```text
n9weather/
├── n9weather.pro           # Qt qmake project file
├── main.cpp                # Native C++ entry point (QDeclarativeView)
├── run.py                  # Standalone Python / PySide runner
├── n9weather.desktop       # MeeGo Harmattan desktop launcher
├── LICENSE                 # MIT License
├── README.md               # Bilingual documentation with screenshots
├── screenshots/            # Screenshots running on actual Nokia N9
│   ├── device_running.jpg
│   ├── ui_screen.jpg
│   └── device_launcher.jpg
├── images/
│   ├── n9weather80.png     # MeeGo Touch 80x80 squircle icon
│   └── cloud.png           # Cloud sprite texture
├── qml/
│   ├── main.qml            # MeeGo PageStackWindow & ToolBar
│   ├── WeatherPage.qml     # Portrait 480x854 layout & logic
│   ├── WeatherIcon.qml     # Pure QML vector icon renderer
│   ├── WeatherDetailCard.qml # Glassmorphism metric badge cards
│   ├── SunEffect.qml       # Animated rotating sun & glowing aura
│   ├── CloudEffect.qml     # Parallax drifting clouds
│   ├── RainEffect.qml      # 60 FPS rain drops & lightning flash
│   └── WeatherService.js   # Open-Meteo REST API parser
└── debian/                 # Debian packaging rules and control
```

---

## 📜 License / Lisans
This project is open-source under the [MIT License](LICENSE).
