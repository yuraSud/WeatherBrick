

import Foundation

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Codable {
    var temp: Double = 0.0
    var pressure: Int = 0
    var humidity: Int = 0
}

struct Wind: Codable {
    var speed: Double = 0.0
}

struct SystemInfoWeather: Codable {
    let country: String
}

struct WeatherData: Codable {
    var weather: [Weather] = []
    var main: Main = Main()
    var name: String = ""
    var wind: Wind = Wind()
    let sys: SystemInfoWeather
}

struct WeatherModel {
    
    var nameCity: String
    var temperature: String
    var description: String
    var wind: Double
    var id: Int
    var temp: Double
    var country: String
    
    var image: String {
        switch id {
        case 200...599 : return "image_stone_wet"
        case 600...699 : return "image_stone_snow"
        default: return temp > 27 ? "image_stone_cracks" : "image_stone_normal"
        }
    }
    
    init?(weatherData: WeatherData) {
        self.nameCity = weatherData.name
        self.temperature = String(format: "%.1f", weatherData.main.temp)
        self.description = weatherData.weather.first?.description ?? "Not found"
        self.wind = weatherData.wind.speed
        self.id = weatherData.weather.first?.id ?? 0
        self.temp = weatherData.main.temp
        self.country = weatherData.sys.country
    }
}

