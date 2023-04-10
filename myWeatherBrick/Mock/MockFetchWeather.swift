

import Foundation


class MockFetchWeather : WeatherFetchingProtocol {
    
    func fetchWeatherForCoordinates(latitude: Double, longitude: Double, completionhandler: @escaping (WeatherModel?) -> ()) {
        
        let url = Bundle.main.url(forResource: "MockKyiv", withExtension: "json")
        guard let data = try? Data(contentsOf: url!) else {return}
        
        do{
            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            
            guard let weatherModel = WeatherModel(weatherData: weatherData) else { return }
            print("123")
           
            //DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                completionhandler(weatherModel)
              //  print("456")
           // }
            print("789")
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func fetchWeatherForCityName(cityName: String, completionhandler: @escaping (WeatherModel?) -> ()) {
        
        let url = Bundle.main.url(forResource: "MockParis", withExtension: "json")
        guard let data = try? Data(contentsOf: url!) else {return}
        
        do{
            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            
            guard let weatherModel = WeatherModel(weatherData: weatherData) else { return }
            
            completionhandler(weatherModel)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
