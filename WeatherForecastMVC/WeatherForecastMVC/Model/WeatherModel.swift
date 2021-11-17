//
//  WeatherModel.swift
//  WeatherForecastMVC
//
//  Created by cong on 11/16/21.
//

import Foundation

struct WeatherModel: Decodable {
    let conditionId: Int
    let city: String
    let temperature: Double
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let temp_max: Double
    let temp_min: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}
