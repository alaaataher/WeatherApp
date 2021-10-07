//
//  WeatherItem.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import Foundation
struct WeatherItem: Equatable {
    
    let temp: Double
    let pressure : Int
    let humidity : Int
    let lat : Float
    let lon : Float
    let weatherDescription: String
    let name: String

}
