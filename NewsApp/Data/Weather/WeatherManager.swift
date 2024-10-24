import Foundation

struct WeatherResponse: Codable {
    let weather: [WeatherData]
    var main: Weather
    let name: String
    var visibility: Int
    var wind: Wind
    var sys: SystemData
    
    struct WeatherData: Codable {
        var main: String
        var description: String
        var icon: String
    }
    
    struct Weather: Codable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var humidity: Double
        var pressure: Double
        var sea_level: Double
        var grnd_level: Double
    }
    
    struct Wind: Codable {
        var speed: Double
    }
    
    struct SystemData: Codable {
        var country: String
    }
}

class WeatherManager: ObservableObject {
    private let apiKey = "2255aeb9e4f7e3edc0195b0627ba2ff6"
    
    func fetchCityWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        // Запрос через URLSession
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }
            
            // Декодируем данные JSON
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
                UserDefaults.standard.set(weatherResponse.sys.country, forKey: "user_country")
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
}
