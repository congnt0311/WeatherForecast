//
//  WeatherData.swift
//  Clima
//
//  Created by cong on 11/3/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

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
