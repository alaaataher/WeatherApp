//
//  WeatherDto.swift
//  WeatherApp
//
//  Created by Alaa Taher on 07/10/2021.
//

import Foundation
struct WeatherDto : Codable {
    let coord : Coord?
    let main : Main?
    let name : String?
    let weather : [Weather]?
    let wind : Wind?
}

struct Coord : Codable {
    let lat : Float?
    let lon : Float?
}

struct Main : Codable {
    let feelsLike : Double?
    let humidity : Int?
    let pressure : Int?
    let temp : Double?
    let tempMax : Double?
    let tempMin : Double?
}
struct Weather : Codable {
    let descriptionField : String?
    let icon : String?
    let id : Int?
    let main : String?

    enum CodingKeys: String, CodingKey {
        case icon = "icon"
        case id = "id"
        case main = "main"
        case descriptionField = "description"
    }
}

struct Wind : Codable {
    let deg : Double?
    let speed : Double?
}
