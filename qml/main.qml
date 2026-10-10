import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow
    initialPage: weatherPage

    showStatusBar: true
    showToolBar: true

    WeatherPage {
        id: weatherPage
    }

    // MeeGo Harmattan Alt Araç Çubuğu
    ToolBarLayout {
        id: commonTools
        visible: true

        ToolIcon {
            iconId: "toolbar-refresh"
            onClicked: weatherPage.refreshWeather()
        }

        ToolIcon {
            iconId: "toolbar-settings"
            onClicked: weatherPage.openCityPicker()
        }
    }
}
