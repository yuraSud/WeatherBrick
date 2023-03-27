

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

struct Sys: Codable {
    let country: String
}

struct WeatherData: Codable {
    var weather: [Weather] = []
    var main: Main = Main()
    var name: String = ""
    var wind: Wind = Wind()
    let sys: Sys
}

