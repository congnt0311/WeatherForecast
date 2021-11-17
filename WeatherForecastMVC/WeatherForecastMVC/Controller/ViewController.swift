//
//  ViewController.swift
//  WeatherForecastMVC
//
//  Created by cong on 11/16/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let weatherURL =  "https://api.openweathermap.org/data/2.5/weather?appid=061928dcda3383cad5f19acf2b53c640&units=metric"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        fetchWeather(cityName: "hanoi")
    }
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        self.performRequest(urlString: urlString)
    }

    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, URLResponse, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.didUpdateWeather(weather: weather)
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON (weatherData: Data) -> WeatherModel? {
            let decoder = JSONDecoder()
            do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                print(decodedData)
                let conditionId = decodedData.weather[0].id
                let temp = decodedData.main.temp
                let name = decodedData.name
                let weather = WeatherModel(conditionId: conditionId, city: name, temperature: temp)
                return weather
            } catch {
              print(error)
                return nil
            }
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async {
            self.descriptionLabel.text = weather.conditionName.description
            self.temperatureLabel.text = "\(weather.temperature)C"
            self.cityNameLabel.text = weather.city
        }
    }
}
