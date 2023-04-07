
import Foundation

protocol WeatherFetchingProtocol {
    
    func fetchWeatherForCoordinates(latitude: Double, longitude: Double, completionhandler: @escaping (WeatherModel?)->())
    
    func fetchWeatherForCityName(cityName: String, completionhandler: @escaping (WeatherModel?)->())
}


struct FetchWeatherManager: WeatherFetchingProtocol {
    
    func fetchWeatherForCoordinates(latitude: Double, longitude: Double, completionhandler: @escaping (WeatherModel?)->()){
        
        let session = URLSession.shared
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=c267c5e8463477badd1859c74d022381&units=metric&lang=uk") else {
            completionhandler(nil)
            return}
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil, let data = data else {
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 3){
                    completionhandler(nil)
                }
                return
            }
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
               
                completionhandler(nil)
            }
            if let weather = parseJSON(data: data) {
                completionhandler(weather)
            }
        }
        task.resume()
    }
    
    func fetchWeatherForCityName(cityName: String, completionhandler: @escaping (WeatherModel?)->()){
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=c267c5e8463477badd1859c74d022381&units=metric&lang=uk") else {
            completionhandler(nil)
            return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil, let data = data else {
                completionhandler(nil)
                return
            }
            
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode) {
                completionhandler(nil)
            }
            
            if let weather = parseJSON(data: data) {
                completionhandler(weather)
            }
        }
        task.resume()
    }
    
    private func parseJSON(data: Data) -> WeatherModel? {
        
        do{
            let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            guard let weatherModel = WeatherModel(weatherData: weatherData) else { return nil
            }
            return weatherModel
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
