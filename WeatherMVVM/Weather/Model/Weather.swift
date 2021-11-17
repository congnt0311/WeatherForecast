//
//  Weather.swift
//  Weather
//

import Foundation

public struct Weather {
    let conditionId: Int
    let city: String
    let temperature: String
    let description: String
    
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

  init(response: APIResponse) {
      conditionId = response.id
      city = response.name
      temperature = "\(Int(response.main.temp))"
      description = response.weather.first?.description ?? ""
  }
}

struct APIResponse: Decodable {
    let id: Int
    let name: String
    let main: APIMain
    let weather: [APIWeather]
}

struct APIMain: Decodable {
    let temp: Double
}

struct APIWeather: Decodable {
    let description: String
    let id: Int
}
